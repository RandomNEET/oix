{
  inputs,
  config,
  lib,
  pkgs,
  opts,
  isExt,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age = {
      sshKeyPaths = [
        (
          if (config.environment ? persistence) then
            "/nix/persist/etc/ssh/ssh_host_ed25519_key"
          else
            "/etc/ssh/ssh_host_ed25519_key"
        )
      ];
    };
    secrets = { } // (opts.sops.secrets or { });
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];

  home-manager.sharedModules = lib.mkIf isExt [
    (
      { config, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        sops = {
          age.keyFile = "${config.xdg.configHome}/sops/keys.txt";
          secrets = { } // (opts.sops.secrets or { });
        };

        home.packages = with pkgs; [
          sops
          age
          ssh-to-age
        ];
      }
    )
  ];
}
