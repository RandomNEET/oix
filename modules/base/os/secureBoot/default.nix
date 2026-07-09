{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
{
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.lanzaboote.nixosModules.lanzaboote
      else
        inputs.lanzaboote-stable.nixosModules.lanzaboote
    )
    ./options.nix
  ];

  config = lib.mkIf config.base.secureBoot.enable {
    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
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
  };
}
