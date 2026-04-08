{ config, lib, ... }:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.base.bluetooth.enable {
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
