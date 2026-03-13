{ pkgs, opts, ... }:
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
        baseKernel = pkgs.${opts.boot.kernelPackages or "linuxPackages"};
        hasPatches = (opts.boot ? kernelPatches) && (opts.boot.kernelPatches != [ ]);
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
