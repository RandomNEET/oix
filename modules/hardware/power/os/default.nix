{ config, ... }:
{
  imports = [ ./options.nix ];

  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower = {
      enable = true;
      usePercentageForPolicy = true;
    };
  };
  security.protectKernelImage = !config.oix.hardware.power.hibernate;
}
