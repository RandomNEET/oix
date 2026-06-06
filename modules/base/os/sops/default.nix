{ config, pkgs, ... }:
{
  sops = {
    age = {
      sshKeyPaths = [
        (
          if config.base.impermanence.enable then
            "/nix/persist/etc/ssh/ssh_host_ed25519_key"
          else
            "/etc/ssh/ssh_host_ed25519_key"
        )
      ];
      # cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
