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
      duckdb = pkgs.yaziPlugins.duckdb;
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
    };
    settings = {
      prepend_fetchers = [
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
          {
            name = "*/";
            run = ''piper -- ${getExe pkgs.eza} -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
          {
            name = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 ${getExe pkgs.glow} -w=$w -s=dark "$1"'';
          }
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
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            name = "*.csv";
            run = "duckdb";
          }
          {
            name = "*.tsv";
            run = "duckdb";
          }
          {
            name = "*.json";
            run = "duckdb";
          }
          {
            name = "*.parquet";
            run = "duckdb";
          }
          {
            name = "*.txt";
            run = "duckdb";
          }
          {
            name = "*.xlsx";
            run = "duckdb";
          }
          {
            name = "*.db";
            run = "duckdb";
          }
          {
            name = "*.duckdb";
            run = "duckdb";
          }
        ];
        repend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            name = "*.csv";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.tsv";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.json";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.parquet";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.txt";
            run = "duckdb";
            multi = false;
          }
          {
            name = "*.xlsx";
            run = "duckdb";
            multi = false;
          }
        ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = "1";
            run = "plugin relative-motions 1";
            desc = "Move in relative steps";
          }
          {
            on = "2";
            run = "plugin relative-motions 2";
            desc = "Move in relative steps";
          }
          {
            on = "3";
            run = "plugin relative-motions 3";
            desc = "Move in relative steps";
          }
          {
            on = "4";
            run = "plugin relative-motions 4";
            desc = "Move in relative steps";
          }
          {
            on = "5";
            run = "plugin relative-motions 5";
            desc = "Move in relative steps";
          }
          {
            on = "6";
            run = "plugin relative-motions 6";
            desc = "Move in relative steps";
          }
          {
            on = "7";
            run = "plugin relative-motions 7";
            desc = "Move in relative steps";
          }
          {
            on = "8";
            run = "plugin relative-motions 8";
            desc = "Move in relative steps";
          }
          {
            on = "9";
            run = "plugin relative-motions 9";
            desc = "Move in relative steps";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          {
            on = "C";
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
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
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = [
              "R"
              "b"
            ];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          {
            on = "T";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
        ]
        ++ lib.optionals config.programs.lazygit.enable [
          {
            on = [
              "g"
              "i"
            ];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
        ];
      };
    };
  };
  home.packages = with pkgs; [
    trash-cli
    mediainfo
    glow
  ];
}
