{ config, lib, ... }:
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.base.power.enable {
    services = {
      power-profiles-daemon = {
        enable = true;
      };
      upower = {
        enable = true;
        usePercentageForPolicy = true;
      };
    };
  };
}
