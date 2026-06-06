{ config, lib, ... }:
{
  config = lib.mkIf (config.base.gpu == "intel-integrated") {
    hardware.intel-gpu-tools = {
      enable = true;
    };
  };
}
