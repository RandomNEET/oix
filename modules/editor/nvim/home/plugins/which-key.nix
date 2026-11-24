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
  config = {
    programs.nixvim = {
      plugins.which-key = {
        enable = true;
        settings = {
          preset = "helix";
        };
        lazyLoad = {
          enable = true;
          settings = {
            event = "DeferredUIEnter";
          };
        };
      };
      highlightOverride = lib.mkIf (osConfig.oix.desktop.themes.enable or false) {
        WhichkeyBorder = {
          fg = colors.base05;
          bg = "none";
        };
        WhichkeyNormal = {
          fg = colors.base05;
          bg = "none";
        };
        WhichkeySeparator = {
          fg = colors.base0B;
          bg = "none";
        };
      };
    };
  };
}
