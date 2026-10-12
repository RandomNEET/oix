{
  lib,
  pkgs,
  ...
}:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "uas"
  ];

  # Instantiate the upstream matched bundle with this host's nixpkgs kernel API.
  boot.kernelPackages = pkgs.linuxAndFirmware.default.linuxPackages_rpi5;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.raspberry-pi = {
    bootloader = "kernel";
    firmwarePath = "/boot/firmware";
    configurationLimit = 3;
    firmwarePackage = pkgs.linuxAndFirmware.default.raspberrypifw;
  };

  # Labels survive moving the SSD from this VM's USB /dev/sdb to Pi PCIe NVMe.
  # These match the existing, unmounted SSD; filesystem contents are unverified.
  fileSystems."/" = {
    device = "/dev/disk/by-label/rootfs";
    fsType = "ext4";
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/bootfs";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  hardware.raspberry-pi.config.all.base-dt-params.pciex1 = {
    enable = true;
    value = "on";
  };

  hardware.graphics.enable = true;

  zramSwap.enable = true;
}
