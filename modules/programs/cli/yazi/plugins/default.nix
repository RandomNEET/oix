{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) getExe;
  desktop = opts.desktop or "";
  hasDesktop = desktop != "";
in
{
  programs.yazi = {
    initLua = builtins.readFile ./init.lua; # init.lua for plugins
    plugins =
      with pkgs.yaziPlugins;
      {
        inherit
          bookmarks
          chmod
          compress
          diff
          full-border
          git
          mediainfo
          ouch
          piper
          recycle-bin
          restore
          smart-filter
          sudo
          toggle-pane
          yatline
          ;
      }
      // lib.optionalAttrs config.programs.lazygit.enable {
        lazygit = pkgs.yaziPlugins.lazygit;
      }
      // lib.optionalAttrs hasDesktop {
        wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      };
    settings = {
      plugin = {
        prepend_fetchers = [
          # git
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
        prepend_previewers = [
          # mediainfo
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
          # ouch
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/vnd.rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
          {
            mime = "application/xz";
            run = "ouch";
          }
          {
            mime = "application/x-zstd";
            run = "ouch";
          }
          {
            mime = "application/zstd";
            run = "ouch";
          }
          {
            mime = "application/java-archive";
            run = "ouch";
          }
          # piper
          {
            url = "*/";
            run = ''piper -- ${getExe pkgs.eza} -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
          {
            url = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 ${getExe pkgs.glow} -w=$w -s=dark "$1"'';
          }
          {
            url = "*.csv";
            run = ''piper -- ${getExe pkgs.bat} -p --color=always "$1"'';
          }
          {
            mime = "application/sqlite3";
            run = ''piper -- ${getExe pkgs.sqlite} "$1" ".schema --indent"'';
          }
        ];
        append_previewers = [
          # piper
          {
            url = "*";
            run = ''piper -- ${getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
          }
        ];
        prepend_preloaders = [
          # mediainfo
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [
          # bookmarks
          {
            on = [ "m" ];
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = [ "'" ];
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [
              "b"
              "d"
            ];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = [
              "b"
              "D"
            ];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
          # chmod
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          # compress
          {
            on = [
              "c"
              "a"
              "a"
            ];
            run = "plugin compress";
            desc = "Archive selected files";
          }
          {
            on = [
              "c"
              "a"
              "p"
            ];
            run = "plugin compress -p";
            desc = "Archive selected files (password)";
          }
          {
            on = [
              "c"
              "a"
              "h"
            ];
            run = "plugin compress -ph";
            desc = "Archive selected files (password+header)";
          }
          {
            on = [
              "c"
              "a"
              "l"
            ];
            run = "plugin compress -l";
            desc = "Archive selected files (compression level)";
          }
          {
            on = [
              "c"
              "a"
              "u"
            ];
            run = "plugin compress -phl";
            desc = "Archive selected files (password+header+level)";
          }
          # diff
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          # recycle-bin
          {
            on = [
              "R"
              "b"
            ];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          # restore
          {
            on = [
              "R"
              "u"
            ];
            run = "plugin restore";
            desc = "Restore last deleted files/folders";
          }
          {
            on = [
              "R"
              "U"
            ];
            run = "plugin restore -- --interactive";
            desc = "Restore deleted files/folders (Interactive)";
          }
          # smart-filter
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          # sudo
          {
            on = [
              "S"
              "p"
              "p"
            ];
            run = "plugin sudo -- paste";
            desc = "sudo paste";
          }
          {
            on = [
              "S"
              "P"
            ];
            run = "plugin sudo -- paste --force";
            desc = "sudo paste";
          }
          {
            on = [
              "S"
              "r"
            ];
            run = "plugin sudo -- rename";
            desc = "sudo rename";
          }
          {
            on = [
              "S"
              "p"
              "l"
            ];
            run = "plugin sudo -- link";
            desc = "sudo link";
          }
          {
            on = [
              "S"
              "p"
              "r"
            ];
            run = "plugin sudo -- link --relative";
            desc = "sudo link relative path";
          }
          {
            on = [
              "S"
              "p"
              "L"
            ];
            run = "plugin sudo -- hardlink";
            desc = "sudo hardlink";
          }
          {
            on = [
              "S"
              "a"
            ];
            run = "plugin sudo -- create";
            desc = "sudo create";
          }
          {
            on = [
              "S"
              "d"
            ];
            run = "plugin sudo -- remove";
            desc = "sudo trash";
          }
          {
            on = [
              "S"
              "D"
            ];
            run = "plugin sudo -- remove --permanently";
            desc = "sudo delete";
          }
          {
            on = [
              "S"
              "m"
            ];
            run = "plugin sudo -- chmod";
            desc = "sudo chmod";
          }
          # toggle-pane
          {
            on = "T";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = "<C-t>";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
        ]
        ++ lib.optionals config.programs.lazygit.enable [
          # lazygit
          {
            on = [
              "g"
              "i"
            ];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
        ]
        ++ lib.optionals hasDesktop [
          # wl-clipboard
          {
            on = "Y";
            run = "plugin wl-clipboard";
            desc = "Copy to system clipboard";
          }
        ];
      };
    };
    extraPackages = with pkgs; [
      ouch
      mediainfo
      trash-cli
    ];
  };
}
