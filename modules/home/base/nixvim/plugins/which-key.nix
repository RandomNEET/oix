{
  osConfig,
  config,
  lib,
  meta,
  ...
}:
let
  hasThemes = osConfig.desktop.themes.enable;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
      };
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
    highlightOverride = lib.mkIf hasThemes {
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
}
