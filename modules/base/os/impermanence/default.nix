{
  inputs,
  options,
  config,
  lib,
  meta,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./options.nix
  ];
  config = lib.mkIf config.base.impermanence.enable {
    environment.persistence = {
      "/nix/persist" = {
        hideMounts = true;
        directories = (
          [
            "/var/log"
            "/var/tmp"
            "/var/lib/nixos"
            "/var/lib/bluetooth"
            "/var/lib/systemd/coredump"
            "/var/lib/systemd/timers"
            "/etc/NetworkManager/system-connections"
            {
              directory = "/var/lib/colord";
              user = "colord";
              group = "colord";
              mode = "u=rwx,g=rx,o=";
            }
          ]
          ++ lib.optional (options.boot ? lanzaboote && config.boot.lanzaboote.enable) "/var/lib/sbctl"
          ++ lib.optional config.services.power-profiles-daemon.enable "/var/lib/power-profiles-daemon"
          ++ lib.optional config.virtualisation.libvirtd.enable "/var/lib/libvirt"
          ++ lib.optional config.virtualisation.docker.enable "/var/lib/docker"
          ++ lib.optional config.virtualisation.waydroid.enable "/var/lib/waydroid"
        );
        files = (
          [
            "/etc/machine-id"
            {
              file = "/etc/nix/id_rsa";
              parentDirectory = {
                mode = "u=rwx,g=rx,o=rx";
              };
            }
          ]
          ++ lib.optionals config.services.openssh.enable [
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
          ]
        );
      };
    };
    system.activationScripts = {
      oix-link = {
        text = ''
          SRC="${meta.flake}"
          DEST="/etc/nixos"

          rm -rf "$DEST"
          mkdir -p "$(dirname "$DEST")"
          ln -sfnT "$SRC" "$DEST"
        '';
        deps = [
          "users"
          "groups"
        ];
      };
    };
  };
}
