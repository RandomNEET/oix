{
  inputs,
  lib,
  pkgs,
  meta,
  ...
}:
{
  imports = [
    ./options.nix
    (
      if (meta.channel == "unstable") then
        inputs.lanzaboote.nixosModules.lanzaboote
      else
        inputs.lanzaboote-stable.nixosModules.lanzaboote
    )
  ];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot
    pkgs.sbctl
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };
}
