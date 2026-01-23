{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors;
in
{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
      settings = {
        preset = "helix";
      };
    };
    highlightOverride = lib.mkIf hasThemes {
      WhichkeyBorder = {
        fg = "#${colors.base05}";
        bg = "none";
      };
      WhichkeyNormal = {
        fg = "#${colors.base05}";
        bg = "none";
      };
      WhichkeySeparator = {
        fg = "#${colors.base0B}";
        bg = "none";
      };
    };
  };
}
