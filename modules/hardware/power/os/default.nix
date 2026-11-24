{ config, ... }:
{
  imports = [ ./options.nix ];

  security.protectKernelImage = !config.oix.hardware.power.hibernate;

  services = {
    power-profiles-daemon = {
      enable = true;
    };
    upower = {
      enable = true;
      usePercentageForPolicy = true;
    };
  };
}
