{ pkgs, meta, ... }:
let
  oix-init = pkgs.writeShellScriptBin "oix-init" ''
    set -e

    REPO="https://github.com/RandomNEET/oix"
    TARGET="${meta.flake}"
    DEST="/etc/nixos"
    BACKUP_SUFFIX=".bak.$(date +%Y%m%d_%H%M%S)"

    if [ ! -d "$TARGET" ]; then
      echo "Cloning repository..."
      ${pkgs.git}/bin/git clone "$REPO" "$TARGET"
    else
      echo "Core directory already exists: $TARGET"
    fi

    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
      if [ ! -L "$DEST" ] && [ -d "$DEST" ] && [ "$(sudo find "$DEST" -maxdepth 1 -mindepth 1 ! -type l | wc -l)" -gt 0 ]; then
        echo "Real files detected in $DEST. Creating backup..."
        sudo mv "$DEST" "$DEST$BACKUP_SUFFIX"
        echo "Backup saved to $DEST$BACKUP_SUFFIX"
      else
        echo "$DEST is a symlink or empty. Removing it to make way..."
        sudo rm -rf "$DEST"
      fi
    fi

    echo "Linking $TARGET to $DEST"
    sudo mkdir -p "$(dirname "$DEST")"
    sudo ln -sfn "$TARGET" "$DEST"

    echo "Initialization complete! $TARGET is linked to $DEST."
  '';
in
{
  environment.systemPackages = [ oix-init ];
}
