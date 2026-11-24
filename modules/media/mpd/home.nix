{ osConfig, lib, ... }:
{
  services = {
    mpd.enable = true;
    mpd-mpris.enable = lib.mkIf (osConfig.oix.desktop.enable or false) true;
  };
}
