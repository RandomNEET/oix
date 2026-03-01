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
    kernelPackages = pkgs.${opts.boot.kernelPackages or "linuxPackages"};
  };
}
