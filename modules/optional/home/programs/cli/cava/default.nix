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

  stylix.targets.cava.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
