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
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      # age-keygen -o ~/.config/sops/age/keys.txt
      # age-keygen -y ~/.config/sops/age/keys.txt
    };
  };

  home = {
    packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
    activation = {
      setupAgeKey = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        AGE_DIR="${config.xdg.configHome}/sops/age"
        KEY_FILE="$AGE_DIR/keys.txt"
        if [ ! -f "$KEY_FILE" ]; then
          $DRY_RUN_CMD mkdir -p "$AGE_DIR"
          $DRY_RUN_CMD ${pkgs.age}/bin/age-keygen -o "$KEY_FILE"
        fi
      '';
    };
  };
}
