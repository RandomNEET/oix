{
  inputs,
  lib,
  pkgs,
  opts,
  isExt,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../../secrets/default.yaml;
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
          defaultSopsFile = ../../../secrets/default.yaml;
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
