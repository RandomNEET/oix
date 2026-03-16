{
  lib,
  pkgs,
  opts,
  ...
}:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [
      "btrfs"
      "exfat"
      "ext4"
      "fat32"
      "ntfs"
    ];
    kernelPackages =
      let
        baseKernel = (opts.boot.kernelPackages or (p: p.linuxPackages)) pkgs;
        hasPatches =
          (lib.hasAttrByPath [ "boot" "kernelPatches" ] opts) && (opts.boot.kernelPatches != [ ]);
      in
      if hasPatches then
        pkgs.linuxPackagesFor (
          baseKernel.kernel.override {
            ignoreConfigErrors = true;
          }
        )
      else
        baseKernel;
    kernelPatches = [ ] ++ (opts.boot.kernelPatches or [ ]);
  };
}
