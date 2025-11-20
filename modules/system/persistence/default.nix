{
  inputs,
  config,
  lib,
  opts,
  ...
}:
{
  # persist
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = (
      [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/bluetooth"
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ]
      ++ lib.optional config.virtualisation.libvirtd.enable "/var/lib/libvirt"
      ++ lib.optional (config.boot.lanzaboote.enable or false) "/var/lib/sbctl"
      ++ (opts.persistence."/nix/persist".directories or [ ])
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
      ++ (opts.persistence."/nix/persist".files or [ ])
    );
  };
}
