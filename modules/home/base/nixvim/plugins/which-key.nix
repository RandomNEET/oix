{
  config,
  lib,
  meta,
  ...
}:
let
  hasThemes = config.desktop.themes.enable;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "helix";
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
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = "DeferredUIEnter";
      };
    };
  };
}
