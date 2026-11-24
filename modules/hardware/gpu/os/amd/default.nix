{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf ((config.oix.hardware.gpu or "none") == "amd") {
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
    environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
    hardware.amdgpu = {
      opencl.enable = true;
    };
  };
}
