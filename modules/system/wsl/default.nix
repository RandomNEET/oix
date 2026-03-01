{ lib, opts, ... }:
{
  boot.loader.systemd-boot.enable = lib.mkForce false;
  networking.wireless.enable = lib.mkForce false;
  security = {
    apparmor.enable = lib.mkForce false;
    protectKernelImage = lib.mkForce false;
  };
  wsl = {
    defaultUser = opts.users.primary.name or "nixos";
  };
}
