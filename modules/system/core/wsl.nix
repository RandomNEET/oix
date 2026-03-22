{
  inputs,
  lib,
  opts,
  isWsl,
  ...
}:
let
  inherit (lib) mkForce;
in
lib.optionalAttrs isWsl {
  boot.loader.systemd-boot.enable = mkForce false;
  networking.wireless.enable = mkForce false;
  security = {
    apparmor.enable = mkForce false;
    protectKernelImage = mkForce false;
  };

  imports = [ inputs.nixos-wsl.nixosModules.default ];
  wsl = {
    enable = true;
    defaultUser = opts.users.primary.name or "nixos";
  };
}
