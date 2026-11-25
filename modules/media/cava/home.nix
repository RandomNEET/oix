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
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.cava.enable = true;
}
