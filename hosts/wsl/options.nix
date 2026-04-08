{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  username = "howl";
  inherit (lib) mkForce;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];
  wsl = {
    enable = true;
    defaultUser = username;
  };

  users = {
    users = {
      "${username}" = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        shell = pkgs.zsh;
      };
    };
  };
  boot.loader.systemd-boot.enable = mkForce false;
  networking.wireless.enable = mkForce false;
  security = {
    apparmor.enable = mkForce false;
    protectKernelImage = mkForce false;
  };
}
