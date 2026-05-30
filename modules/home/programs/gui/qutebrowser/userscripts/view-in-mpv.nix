# Requirements: programs.mpv.enable = true;
{ pkgs, ... }:
pkgs.writeShellScript "view-in-mpv" ''
  set -e

  if [ -z "$QUTE_FIFO" ] ; then
      cat 1>&2 <<EOF
  Error: $0 can not be run as a standalone script.

  It is a qutebrowser userscript. In order to use it, call it using
  'spawn --userscript' as described in qute://help/userscripts.html
  EOF
      exit 1
  fi

  msg() {
      local cmd="$1"
      shift
      local msg="$*"
      if [ -z "$QUTE_FIFO" ] ; then
          echo "$cmd: $msg" >&2
      else
          echo "message-$cmd ' ''${msg//\'/\\\'}'" >> "$QUTE_FIFO"
      fi
  }

  MPV_COMMAND=''${MPV_COMMAND:-${pkgs.mpv}/bin/mpv}
  # Warning: spaces in single flags are not supported
  MPV_FLAGS=''${MPV_FLAGS:- --force-window --quiet --keep-open=yes --ytdl}
  IFS=" " read -r -a video_command <<< "$MPV_COMMAND $MPV_FLAGS"

  js() {
  cat <<EOF

      function descendantOfTagName(child, ancestorTagName) {
          while (child.parentNode != null) {
              child = child.parentNode;
              if (typeof child.tagName === 'undefined') break;
              if (child.tagName.toUpperCase() == ancestorTagName.toUpperCase()) {
                  return true;
              }
          }
          return false;
      }

      var App = {};

      var all_videos = [];
      all_videos.push.apply(all_videos, document.getElementsByTagName("video"));
      all_videos.push.apply(all_videos, document.getElementsByTagName("object"));
      all_videos.push.apply(all_videos, document.getElementsByTagName("embed"));
      App.backup_videos = Array();
      App.all_replacements = Array();
      for (i = 0; i < all_videos.length; i++) {
          var video = all_videos[i];
          if (descendantOfTagName(video, "object")) {
              continue;
          }
          var replacement = document.createElement("div");
          replacement.innerHTML = "
              <p style=\\"margin-bottom: 0.5em\\">
              Opening page with:
              <span style=\\"font-family: monospace;\\">''${video_command[*]}</span>
              </p>
              <p>
              In order to restore this particular video
              <a style=\\"font-weight: bold;
                          color: white;
                          background: transparent;
                          cursor: pointer;
                       \\"
                 onClick=\\"restore_video(this, " + i + ");\\"
                >click here</a>.
              </p>
          ";
          replacement.style.position = "relative";
          replacement.style.zIndex = "100003000000";
          replacement.style.fontSize = "1rem";
          replacement.style.textAlign = "center";
          replacement.style.verticalAlign = "middle";
          replacement.style.height = "100%";
          replacement.style.background = "#101010";
          replacement.style.color = "white";
          replacement.style.border = "4px dashed #545454";
          replacement.style.padding = "2em";
          replacement.style.margin = "auto";
          App.all_replacements[i] = replacement;
          App.backup_videos[i] = video;
          video.parentNode.replaceChild(replacement, video);
      }

      function restore_video(obj, index) {
          obj = App.all_replacements[index];
          video = App.backup_videos[index];
          obj.parentNode.replaceChild(video, obj);
      }

      var siteHeader = document.getElementById('header');
      siteHeader.style.display='none';
      siteHeader.offsetHeight;
      siteHeader.style.display='block';

  EOF
  }

  printjs() {
      js | ${pkgs.gnused}/bin/sed 's,//.*$,,' | ${pkgs.coreutils}/bin/tr '\n' ' '
  }
  echo "jseval -q -w main $(printjs)" >> "$QUTE_FIFO"

  msg info "Opening $QUTE_URL with mpv"
  "''${video_command[@]}" "$@" "$QUTE_URL"
''
