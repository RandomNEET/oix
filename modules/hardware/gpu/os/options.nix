{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    oix.hardware = {
      gpu = mkOption {
        type = types.enum [
          "amd"
          "intel-integrated"
          "nvidia"
          "none"
        ];
        default = "none";
        description = ''
          Primary GPU vendor and driver stack to configure for the system.

          - `"amd"`: Enable the `amdgpu` driver, ROCm OpenCL support, and `amdsmi`.
          - `"intel-integrated"`: Enable Intel integrated graphics tooling (`intel-gpu-tools`).
          - `"nvidia"`: Enable the open-source NVIDIA kernel modules, VA-API/VDPAU video acceleration, Wayland environment variables, and the `nixos-cuda` binary cache.
          - `"none"`: Do not configure dedicated GPU drivers (suitable for headless servers or virtual machines).
        '';
      };
    };
  };
}
