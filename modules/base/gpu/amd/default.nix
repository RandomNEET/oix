{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.base.gpu == "amd") {
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
