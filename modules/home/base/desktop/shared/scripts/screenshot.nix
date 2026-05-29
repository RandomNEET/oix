# Requirements: satty grim slurp wayfreeze tesseract libnotify wl-clipboard
{ config, pkgs, ... }:
pkgs.writeShellScriptBin "screenshot" ''
  XDG_PICTURES_DIR="${config.xdg.userDirs.pictures}"
  SCREENSHOT_DIR="$XDG_PICTURES_DIR/screenshots"
  TEMP_OCR_FILE="/tmp/ocr_screenshot.png"
  OCR_LANGS="eng+chi_sim+chi_tra+jpn+kor"
  LOCK_FILE="/tmp/screenshot_''${USER}.lock"
  PID_FILE="/tmp/screenshot_''${USER}.pid"

  cleanup() {
      jobs -p | xargs -r kill 2>/dev/null
      rm -f "$PID_FILE" "$LOCK_FILE"
      exec 200>&- 2>/dev/null
  }
  trap cleanup EXIT INT TERM

  exec 200>"$LOCK_FILE"
  if ! flock -n 200; then
      if [ -f "$PID_FILE" ]; then
          pid=$(cat "$PID_FILE")
          pkill -P "$pid" 2>/dev/null
          kill "$pid" 2>/dev/null
      fi
      pkill -x wayfreeze 2>/dev/null
      pkill -x slurp 2>/dev/null
      sleep 0.1
      rm -f "$PID_FILE" "$LOCK_FILE"
      exit 0
  fi

  echo $$ >"$PID_FILE"

  prepare_env() {
    mkdir -p "$SCREENSHOT_DIR"
    local timestamp
    timestamp=$(date +'%Y-%m-%d-%H:%M:%S')
    SCREENSHOT_FILE="$SCREENSHOT_DIR/screenshot-''${timestamp}.png"
  }

  check_dependencies() {
    local deps=(grim slurp satty notify-send tesseract wl-copy wayfreeze)
    for cmd in "''${deps[@]}"; do
      if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' not found."
        exit 1
      fi
    done
  }

  freeze_and_select() {
    local tmpfile
    tmpfile=$(mktemp) || return 1

    wayfreeze --hide-cursor &
    local freeze_pid=$!
    sleep 0.1

    slurp -b '#00000000' -c '#FFFFFFFF' -s '#00000000' -B '#00000000' "$@" >"$tmpfile" 2>/dev/null &
    local slurp_pid=$!

    wait -n 2>/dev/null

    kill "$freeze_pid" "$slurp_pid" 2>/dev/null
    wait 2>/dev/null

    if [ -s "$tmpfile" ]; then
        cat "$tmpfile"
        rm -f "$tmpfile"
        return 0
    fi

    rm -f "$tmpfile"
    return 1
  }

  print_usage() {
    cat <<EOF
  Usage: $(basename "$0") <action>
  Actions:
    s  : Area capture with screen freeze
    a  : Fullscreen capture (all screens)
    o  : OCR capture (area to clipboard, multi-language)
  EOF
    exit 1
  }

  check_dependencies

  case "$1" in
  s)
    prepare_env
    region=$(freeze_and_select -od)
    if [ -n "$region" ]; then
      grim -g "$region" /tmp/screenshot_input_''$$.png
      exec 200>&-
      satty --filename /tmp/screenshot_input_''$$.png --output-filename "$SCREENSHOT_FILE"
      rm -f /tmp/screenshot_input_''$$.png
    fi
    ;;
  a)
    prepare_env
    grim /tmp/screenshot_input_''$$.png
    exec 200>&-
    satty --filename /tmp/screenshot_input_''$$.png --output-filename "$SCREENSHOT_FILE" --fullscreen all
    rm -f /tmp/screenshot_input_''$$.png
    ;;
  o)
    region=$(freeze_and_select)
    if [ -n "$region" ]; then
      grim -g "$region" "$TEMP_OCR_FILE"
      exec 200>&-
      ocr_text=$(tesseract "$TEMP_OCR_FILE" stdout -l "$OCR_LANGS" 2>/dev/null)
      if [ -n "$ocr_text" ]; then
        echo -n "$ocr_text" | wl-copy
        notify-send -a "screenshot" -u low -i "edit-paste" \
          "OCR Success" "Text copied to clipboard"
      else
        notify-send -a "screenshot" -u low -i "dialog-error" \
          "OCR Error" "Failed to recognize text"
      fi
      rm -f "$TEMP_OCR_FILE"
    fi
    ;;
  *)
    print_usage
    ;;
  esac
''
