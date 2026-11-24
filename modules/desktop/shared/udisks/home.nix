{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.services.udisks2.enable {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
