{ config, lib, ... }:
{
  config = lib.mkIf (config.oix.hardware.gpu == "intel-integrated") {
    hardware.intel-gpu-tools = {
      enable = true;
    };
  };
}
