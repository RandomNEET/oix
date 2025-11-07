{ pkgs, opts, ... }:
pkgs.writeShellScript "mbsync-count" ''
  MAILDIR="${opts.mbsync.notify.mailDir}"
  COUNT_FILE="${opts.mbsync.notify.countFile}"

  NEW_COUNT=$(find "$MAILDIR" -type d -name new -exec find {} -type f \; | wc -l)
  OLD_COUNT=0
  [ -f "$COUNT_FILE" ] && OLD_COUNT=$(cat "$COUNT_FILE")

  if (( NEW_COUNT != OLD_COUNT )); then
    echo "$NEW_COUNT" > "$COUNT_FILE"
  fi
''
