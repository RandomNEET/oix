{ config, pkgs, ... }:
if config.services.power-profiles-daemon.enable then
  pkgs.writeShellScriptBin "powermodectl" ''
    MODE_FILE="$HOME/.config/niri/power-mode"
    mkdir -p "$(dirname "$MODE_FILE")"

    sync() {
      ACTIVE_MODE=$(powerprofilesctl list | grep '^\*' | awk '{print $2}' | tr -d ':')
      case "$ACTIVE_MODE" in
        performance) NEW_MODE="performance" ;;
        balanced) NEW_MODE="balanced" ;;
        power-saver) NEW_MODE="powersave" ;;
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
        performance) echo "powerprofilesctl set performance" ;;
        balanced) echo "powerprofilesctl set balanced" ;;
        toggle)
          if [[ "$CURRENT" == "performance" ]]; then
            echo "powerprofilesctl set balanced"
          else
            echo "powerprofilesctl set performance"
          fi
          ;;
      esac
    }

    toggle() {
      CMD=$(get_cmd toggle)
      if $CMD >/dev/null 2>&1; then
        if [[ "$CURRENT" == "performance" ]]; then
          echo "balanced" >"$MODE_FILE"
        else
          echo "performance" >"$MODE_FILE"
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
else if config.services.tlp.enable then
  pkgs.writeShellScriptBin "powermodectl" ''
    MODE_FILE="$HOME/.config/niri/power-mode"
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
