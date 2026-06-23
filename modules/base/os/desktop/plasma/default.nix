{ config, lib, ... }:
{
  config = lib.mkIf config.desktop.plasma.enable {
    services = {
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
      xserver.enable = config.desktop.plasma.x11Support;
    };
  };
}
