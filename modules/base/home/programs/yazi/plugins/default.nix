{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe optionalAttrs optionals;
  hasDesktop = osConfig.desktop.enable;
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
          diff
          full-border
          git
          mediainfo
          piper
          smart-filter
          toggle-pane
          ;
        # TEMPFIX: compress 0.6 uses fs.unique_name, removed in Yazi 26.9.1.
        # Remove this override once the packaged plugin uses fs.unique upstream.
        # Upstream: https://github.com/KKV9/compress.yazi/blob/main/main.lua
        compress = pkgs.yaziPlugins.compress.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace main.lua \
              --replace-fail 'fs.unique_name(Url(temp_dir))' 'fs.unique("dir", Url(temp_dir))' \
              --replace-fail 'fs.unique_name(Url(final_output_url))' 'fs.unique("file", Url(final_output_url))'
          '';
        });
      }
      // optionalAttrs config.programs.lazygit.enable {
        lazygit = pkgs.yaziPlugins.lazygit;
      }
      // optionalAttrs hasDesktop {
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
            group = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "git";
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
            on = [ "M" ];
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
            on = "<A-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          # smart-filter
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
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
        ++ optionals config.programs.lazygit.enable [
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
        ++ optionals hasDesktop [
          # wl-clipboard
          {
            on = "Y";
            run = "plugin wl-clipboard";
            desc = "Copy to system clipboard";
          }
        ];
      };
    };
    extraPackages =
      with pkgs;
      [
        # mediainfo
        mediainfo
      ]
      ++ optionals hasDesktop [
        # wl-clipboard
        wl-clipboard
      ];
  };
}
