{ config, lib, ... }:
{
  config = lib.mkIf config.desktop.enable {
    services = {
      udisks2.enable = true;
    };
  };
}
