{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins = {
      noice = {
        enable = true;
        settings = {
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
        };
      };
    };
    highlightOverride = lib.mkIf hasThemes {
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
