{ pkgs, opts, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    kernelPackages = pkgs.${opts.boot.kernelPackages or "linuxPackages"};
  };
}
