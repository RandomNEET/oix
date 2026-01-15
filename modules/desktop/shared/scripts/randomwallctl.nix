{
  lib,
  pkgs,
  opts,
  ...
}:
let
  desktop =
    if (lib.strings.hasInfix "hyprland" opts.desktop) then
      "hyprland"
    else if (lib.strings.hasInfix "niri" opts.desktop) then
      "niri"
    else
      "";
in
pkgs.writeShellScript "randonwallctl" ''
  STATE_FILE="$XDG_STATE_HOME/${desktop}/random-wall"

  mkdir -p "$(dirname "$STATE_FILE")"

  sync() {
  	if systemctl --user is-active --quiet random-wall.timer; then
  		NEW_STATE="enabled"
  	else
  		NEW_STATE="disabled"
  	fi

  	CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "")
  	if [[ "$NEW_STATE" != "$CURRENT_STATE" ]]; then
  		echo "$NEW_STATE" >"$STATE_FILE"
  	fi
  }

  if [[ ! -s "$STATE_FILE" ]]; then
  	sync
  fi

  CURRENT=$(cat "$STATE_FILE")

  get_cmd() {
  	local mode="$1"
  	case "$mode" in
  	enabled) echo "systemctl --user enable --now random-wall.timer" ;;
  	disabled) echo "systemctl --user stop --now random-wall.timer" ;;
  	toggle)
  		if [[ "$CURRENT" == "enabled" ]]; then
  			echo "systemctl --user stop --now random-wall.timer"
  		else
  			echo "systemctl --user enable --now random-wall.timer"
  		fi
  		;;
  	esac
  }

  toggle() {
  	CMD=$(get_cmd toggle)
  	if $CMD >/dev/null 2>&1; then
  		sync
  	fi
  }

  restore() {
  	CMD=$(get_cmd "$CURRENT")
  	if $CMD >/dev/null 2>&1; then
  		sync
  	fi
  }

  case "$1" in
  -t | --toggle)
  	toggle
  	;;
  -r | --restore)
  	restore
  	;;
  -s | --sync)
  	sync
  	;;
  *)
  	echo "Usage: $0 [-t|--toggle] [-r|--restore] [-s|--sync]"
  	;;
  esac
''
