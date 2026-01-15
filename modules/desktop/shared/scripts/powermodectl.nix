{
  config,
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
if config.services.power-profiles-daemon.enable then
  pkgs.writeShellScript "powermodectl" ''
    MODE_FILE="$XDG_STATE_HOME/${desktop}/power-mode"

    mkdir -p "$(dirname "$MODE_FILE")"

    get_current() {
        powerprofilesctl list | grep '^\*' | awk '{print $2}' | tr -d ':'
    }

    apply_and_save() {
        local mode=$1
        if powerprofilesctl set "$mode" >/dev/null 2>&1; then
            echo "$mode" > "$MODE_FILE"
        else
            exit 1
        fi
    }

    case "$1" in
        -t|--toggle)
            [[ "$(get_current)" == "performance" ]] && apply_and_save "balanced" || apply_and_save "performance"
            ;;
            
        -r|--restore)
            if [[ -s "$MODE_FILE" ]]; then
                powerprofilesctl set "$(cat "$MODE_FILE")" >/dev/null 2>&1
            else
                get_current > "$MODE_FILE"
            fi
            ;;
            
        -s|--sync)
            get_current > "$MODE_FILE"
            ;;

        *)
            echo "Usage: $0 [-t|--toggle] | [-r|--restore] | [-s|--sync]"
            exit 1
            ;;
    esac
  ''
else if config.services.tlp.enable then
  pkgs.writeShellScript "powermodectl" ''
    MODE_FILE="$XDG_STATE_HOME/${desktop}/power-mode"
    mkdir -p "$(dirname "$MODE_FILE")"

    sync() {
      MODE=$(tlp-stat -s 2>/dev/null | awk -F'= *' '/^Mode/ {print $2}' | xargs)
      case "$MODE" in
        "AC"|"battery") NEW_MODE="auto" ;;
        "AC (manual)"|"battery (manual)") NEW_MODE="manual" ;;
      esac
      CURRENT=$(cat "$MODE_FILE" 2>/dev/null || echo "")
      if [[ "$NEW_MODE" != "$CURRENT" ]]; then
        echo "$NEW_MODE" >"$MODE_FILE"
      fi
    }

    if [[ ! -s "$MODE_FILE" ]]; then
    	sync
    fi
    CURRENT=$(cat "$MODE_FILE")

    get_cmd() {
      local mode="$1"
      case "$mode" in
        manual) echo "pkexec tlp ac" ;;
        auto) echo "pkexec tlp start" ;;
        toggle)
          if [[ "$CURRENT" == "manual" ]]; then
            echo "pkexec tlp start"
          else
            echo "pkexec tlp ac"
          fi
          ;;
      esac
    }

    toggle() {
      CMD=$(get_cmd toggle)
      if $CMD >/dev/null 2>&1; then
        if [[ "$CURRENT" == "manual" ]]; then
          echo "auto" >"$MODE_FILE"
        else
          echo "manual" >"$MODE_FILE"
        fi
      fi
    }

    restore() {
      CMD=$(get_cmd "$CURRENT")
      $CMD >/dev/null 2>&1
    }

    case "$1" in
      -t|--toggle) toggle ;;
      -r|--restore) restore ;;
      -s|--sync) sync ;;
      *) echo "Usage: $0 [-t|--toggle] | [-r|--restore] | [-s|--sync]" ;;
    esac
  ''
else
  null
