{ pkgs, opts, ... }:
if (opts.hostname or "") == "dix" then
  pkgs.writeShellScriptBin "backup" ''
    set -euo pipefail
    cd ~/

    echo "==> Encrypting vault..."
    sudo tar czf vault.tar.gz ~/.vault
    gpg -e -r neet@randomneet.me vault.tar.gz && rm -f vault.tar.gz
    mv -v ~/vault.tar.gz.gpg /mnt/hdd2/backup

    echo "==> Backing up user directories..."
    for dir in nixos doc pic pkg repo vid .local/share/zsh; do
      echo "--> $dir"
      rsync -aAXH --delete --no-links --human-readable --quiet \
        --info=NAME,REMOVE,DEL \
        "$HOME/$dir" /mnt/hdd2/backup
    done

    echo "==> Backup complete."
  ''
else if opts.hostname != null && opts.hostname == "nasix" then
  pkgs.writeShellScriptBin "backup" ''
    set -euo pipefail

    echo "==> Backing up nixos configs..."
    rsync -aAXH --delete --no-links --human-readable --quiet \
      --info=NAME,REMOVE,DEL \
      ~/nixos /mnt/ssd/backup/nixos

    echo "==> Backing up docker data..."
    sudo rsync -aAXH --delete --no-links --human-readable --quiet \
      --info=NAME,REMOVE,DEL \
      ~/.docker /mnt/ssd/backup/docker

    echo "==> Backing up service data..."
    for dir in \
      /var/lib/vaultwarden \
      /var/lib/jellyfin \
      /var/lib/qBittorrent \
      /var/lib/freshrss \
      /var/lib/calibre-web; do
      echo "--> $dir"
      sudo rsync -aAXH --delete --no-links --human-readable --quiet \
        --info=NAME,REMOVE,DEL \
        "$dir" /mnt/ssd/backup/var/lib
    done

    echo "==> Backing up cache data..."
    sudo rsync -aAXH --delete --no-links --human-readable --quiet \
      --info=NAME,REMOVE,DEL \
      /var/cache/jellyfin /mnt/ssd/backup/var/cache

    echo "==> Backup complete."
  ''
else
  null
