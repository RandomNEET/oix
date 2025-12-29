{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) getExe getExe';
in
{
  programs.yazi = {
    initLua =
      builtins.readFile ./init.lua
      + lib.optionalString ((opts.theme or "") != "") (import (./themes + "/${opts.theme}.nix")).yatline;
    plugins = {
      piper = pkgs.yaziPlugins.piper;
      ouch = pkgs.yaziPlugins.ouch;
      mediainfo = pkgs.yaziPlugins.mediainfo;
      relative-motions = pkgs.yaziPlugins.relative-motions;
      smart-filter = pkgs.yaziPlugins.smart-filter;
      sudo = pkgs.yaziPlugins.sudo;
      chmod = pkgs.yaziPlugins.chmod;
      recycle-bin = pkgs.yaziPlugins.recycle-bin;
      git = pkgs.yaziPlugins.git;
      diff = pkgs.yaziPlugins.diff;
      yatline = pkgs.yaziPlugins.yatline;
      full-border = pkgs.yaziPlugins.full-border;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
    }
    // lib.optionalAttrs config.programs.lazygit.enable {
      lazygit = pkgs.yaziPlugins.lazygit;
    }
    // lib.optionalAttrs ((opts.desktop or "") != "") {
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
    };
    settings = {
      prepend_fetchers = [
        # git
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
      plugin = {
        prepend_previewers = [
          # piper
          {
            name = "*/";
            run = ''piper -- ${getExe pkgs.eza} -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
          {
            name = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 ${getExe pkgs.glow} -w=$w -s=dark "$1"'';
          }
          {
            name = "*.csv";
            run = ''piper -- ${getExe pkgs.bat} -p --color=always "$1"'';
          }
          {
            mime = "application/sqlite3";
            run = ''piper -- ${getExe pkgs.sqlite} "$1" ".schema --indent"'';
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
          # mediainfo
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
        ];
        append_previewers = [
          # piper
          {
            name = "*";
            run = ''piper -- ${getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
          }
        ];
        repend_preloaders = [
          # mediainfo
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
        ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [
          # relative-motions
          {
            on = "m";
            run = "plugin relative-motions";
            desc = "Trigger a new relative motion";
          }
          # smart-filter
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          # ouch
          {
            on = "C";
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
          # sudo
          {
            on = [
              "R"
              "p"
              "p"
            ];
            run = "plugin sudo -- paste";
            desc = "sudo paste";
          }
          {
            on = [
              "R"
              "P"
            ];
            run = "plugin sudo -- paste --force";
            desc = "sudo paste";
          }
          {
            on = [
              "R"
              "r"
            ];
            run = "plugin sudo -- rename";
            desc = "sudo rename";
          }
          {
            on = [
              "R"
              "p"
              "l"
            ];
            run = "plugin sudo -- link";
            desc = "sudo link";
          }
          {
            on = [
              "R"
              "p"
              "r"
            ];
            run = "plugin sudo -- link --relative";
            desc = "sudo link relative path";
          }
          {
            on = [
              "R"
              "p"
              "L"
            ];
            run = "plugin sudo -- hardlink";
            desc = "sudo hardlink";
          }
          {
            on = [
              "R"
              "a"
            ];
            run = "plugin sudo -- create";
            desc = "sudo create";
          }
          {
            on = [
              "R"
              "d"
            ];
            run = "plugin sudo -- remove";
            desc = "sudo trash";
          }
          {
            on = [
              "R"
              "D"
            ];
            run = "plugin sudo -- remove --permanently";
            desc = "sudo delete";
          }
          {
            on = [
              "R"
              "m"
            ];
            run = "plugin sudo -- chmod";
            desc = "sudo chmod";
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
          # recycle-bin
          {
            on = [
              "R"
              "b"
            ];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          # diff
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
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
        ++ lib.optionals ((opts.desktop or "") != "") [
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
