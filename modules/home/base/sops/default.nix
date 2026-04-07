{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
  };

  home = {
    packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
    activation = {
      setupSshKey = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        SSH_DIR="${config.home.homeDirectory}/.ssh"
        KEY_FILE="$SSH_DIR/id_ed25519"
        if [ ! -f "$KEY_FILE" ]; then
          $DRY_RUN_CMD mkdir -p "$SSH_DIR"
          $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -q
        fi
      '';
    };
  };
}
