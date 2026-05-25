{ config, lib, ... }:
{
  config = lib.mkIf config.desktop.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      protectKernelImage = !config.desktop.hibernate;
    };
  };
}
