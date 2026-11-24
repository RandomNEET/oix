{ config, lib, ... }:
{
  config = lib.mkIf ((config.oix.hardware.gpu or "none") == "intel-integrated") {
    hardware.intel-gpu-tools = {
      enable = true;
    };
  };
}
