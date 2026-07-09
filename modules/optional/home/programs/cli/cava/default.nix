{ osConfig, lib, ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        framerate = 60;
        sensitivity = 100; # Default
        autosens = 1;
      };
    };
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.cava.enable = true;
}
