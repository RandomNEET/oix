{
  inputs,
  config,
  pkgs,
  meta,
  ...
}:
{
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.sops-nix.nixosModules.sops
      else
        inputs.sops-nix-stable.nixosModules.sops
    )
  ];

  sops = {
    age = {
      sshKeyPaths = [
        (
          if (config.oix.storage.impermanence.enable or false) then
            "${config.oix.storage.impermanence.persistDir}/etc/ssh/ssh_host_ed25519_key"
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
