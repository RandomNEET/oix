{ pkgs, ... }:
let
  isNixos = true;
  isNixosEnv = if isNixos then "true" else "false";
  oix-init = pkgs.writeShellScriptBin "oix-init" ''
    set -e

    REPO="https://github.com/RandomNEET/oix"
    TARGET="$HOME/oix"
    BACKUP_SUFFIX=".bak.$(date +%Y%m%d_%H%M%S)"

    if [ ! -d "$TARGET" ]; then
      echo "Cloning repository..."
      ${pkgs.git}/bin/git clone "$REPO" "$TARGET"
    else
      echo "Core directory already exists: $TARGET"
    fi

    if [ "${isNixosEnv}" = "true" ]; then
      DEST="/etc/nixos"
      SUDO="sudo"
    else
      DEST="$HOME/.config/home-manager"
      SUDO=""
    fi

    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
      if [ ! -L "$DEST" ] && [ -d "$DEST" ] && [ "$($SUDO find "$DEST" -maxdepth 1 -mindepth 1 ! -type l | wc -l)" -gt 0 ]; then
        echo "Real files detected in $DEST. Creating backup..."
        $SUDO mv "$DEST" "$DEST$BACKUP_SUFFIX"
        echo "Backup saved to $DEST$BACKUP_SUFFIX"
      else
        echo "$DEST is a symlink or empty. Removing it to make way..."
        $SUDO rm -rf "$DEST"
      fi
    fi

    echo "Linking $TARGET to $DEST"
    $SUDO mkdir -p "$(dirname "$DEST")"
    $SUDO ln -sfn "$TARGET" "$DEST"

    echo "Initialization complete! $TARGET is linked to $DEST."
  '';
in
{
  environment.systemPackages = [ oix-init ];
}
