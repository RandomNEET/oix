{
  osConfig,
  config,
  lib,
  meta,
  ...
}:
let
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
    highlightOverride = lib.mkIf osConfig.desktop.themes.enable {
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
