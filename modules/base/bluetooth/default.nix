{ config, lib, ... }:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.base.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
