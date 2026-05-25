{ config, lib, ... }:
{
  imports = [
    ../shared/fonts
    ../shared/themes
  ];

  config = lib.mkIf config.desktop.plasma.enable {
    services.desktopManager = {
      plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };
  };
}
