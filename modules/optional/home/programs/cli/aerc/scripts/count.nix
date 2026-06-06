{ config, pkgs, ... }:
pkgs.writeShellScript "mbsync-count" ''
  MAILDIR="${config.accounts.email.maildirBasePath}"
  COUNT_FILE="${config.accounts.email.maildirBasePath}/.new"

  if [ ! -f "$COUNT_FILE" ]; then
    echo 0 > "$COUNT_FILE"
  fi

  NEW_COUNT=$(find "$MAILDIR" -type d -name new -exec find {} -type f \; | wc -l)
  OLD_COUNT=0
  [ -f "$COUNT_FILE" ] && OLD_COUNT=$(cat "$COUNT_FILE")

  if (( NEW_COUNT != OLD_COUNT )); then
    echo "$NEW_COUNT" > "$COUNT_FILE"
  fi
''
