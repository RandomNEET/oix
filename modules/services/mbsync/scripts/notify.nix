{ pkgs, opts, ... }:
pkgs.writeShellScript "notify" ''
  MAILDIR="${opts.mbsync.notify.mailDir}"
  COUNT_FILE="${opts.mbsync.notify.countFile}"

  NEW_COUNT=$(find "$MAILDIR" -type d -name new -exec find {} -type f \; | wc -l)
  OLD_COUNT=0
  [ -f "$COUNT_FILE" ] && OLD_COUNT=$(cat "$COUNT_FILE")

  if (( NEW_COUNT > OLD_COUNT )); then
    NEW_MAILS=$((NEW_COUNT - OLD_COUNT))
    notify-send -i mail-unread "New Mail" "You have $NEW_MAILS new email(s)"
  fi

  if (( NEW_COUNT != OLD_COUNT )); then
    echo "$NEW_COUNT" > "$COUNT_FILE"
  fi
''
