{ osConfig, lib, ... }:
{
  services = {
    mpd.enable = true;
    mpd-mpris.enable = lib.mkIf osConfig.desktop.enable true;
  };
}
