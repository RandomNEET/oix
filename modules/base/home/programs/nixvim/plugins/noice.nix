{
  osConfig,
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      settings = {
        cmdline = {
          format = {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "^%?";
              icon = " ";
              lang = "regex";
            };
            shell = {
              pattern = "^:!";
              icon = "";
              lang = "bash";
            };
            filter = {
              pattern = "^:[%%.,1-9$'<,>].*!";
              icon = "";
              lang = "bash";
            };
            lua = {
              pattern = [
                "^:%s*lua%s+"
                "^:%s*lua%s*=%s*"
                "^:%s*=%s*"
              ];
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "󰋖";
            };
            input = {
              view = "cmdline_input";
              icon = "󰥻 ";
            };
          };
        };
        views = {
          cmdline_popup = {
            position = {
              row = 3;
              col = "50%";
            };
            size = {
              width = 60;
              height = "auto";
            };
          };
          popupmenu = {
            relative = "editor";
            position = {
              row = 6;
              col = "50%";
            };
            size = {
              width = 60;
              height = 10;
            };
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
          };
        };
        routes = [
          # https://github.com/folke/noice.nvim/issues/1097
          {
            view = "notify";
            filter = {
              event = "msg_show";
              kind = [
                "shell_out"
                "shell_err"
              ];
            };
          }
        ];
      };
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
    highlightOverride = lib.mkIf osConfig.desktop.themes.enable {
      NoiceCmdlineIcon = {
        fg = colors.base0C;
        bg = "none";
      };
      NoiceCmdlineIconSearch = {
        fg = colors.base0E;
        bg = "none";
      };
      NoiceCmdlinePopupBorderSearch = {
        fg = colors.base0E;
        bg = "none";
      };
    };
  };
}
