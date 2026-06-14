{
  osConfig,
  config,
  lib,
  ...
}:
let
  inherit (osConfig.desktop.fonts) monospace sansSerif serif;
  headName = fonts: (builtins.head fonts).name;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  config = lib.mkIf osConfig.desktop.enable {
    programs.satty = {
      enable = true;
      settings = {
        general = {
          fullscreen = true;
          early-exit = [ "all" ];
          copy-command = "wl-copy";
          actions-on-right-click = [ "save-to-clipboard" ];
          actions-on-enter = [ "save-to-file" ];
          actions-on-escape = [ "exit" ];
          no-window-decoration = true;
        };
      }
      // lib.optionalAttrs osConfig.desktop.themes.enable {
        font = {
          family = headName monospace;
          fallback = map headName [
            sansSerif
            serif
          ];
        };
        color-palette = {
          palette = [
            colors.base0C
            colors.base08
            colors.base0E
            colors.base0A
            colors.base0B
            colors.base0D
          ];
        };
      };
    };
  };
}
