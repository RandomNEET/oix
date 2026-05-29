# Requirements: satty grim slurp wayfreeze tesseract libnotify wl-clipboard
{ config, pkgs, ... }:
pkgs.writeShellScriptBin "screenshot" ''
  XDG_PICTURES_DIR="${config.xdg.userDirs.pictures}"
  SCREENSHOT_DIR="$XDG_PICTURES_DIR/screenshots"
  TEMP_OCR_FILE="/tmp/ocr_screenshot.png"
  OCR_LANGS="eng+chi_sim+chi_tra+jpn+kor"

  prepare_env() {
    mkdir -p "$SCREENSHOT_DIR"
    local timestamp
    timestamp=$(date +'%y%m%d_%Hh%Mm%Ss')
    SCREENSHOT_FILE="$SCREENSHOT_DIR/''${timestamp}_screenshot.png"
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
    wayfreeze --hide-cursor & local freeze_pid=$!
    sleep 0.1
    local region
    region=$(slurp "$@") || { kill "$freeze_pid" 2>/dev/null; return 1; }
    kill "$freeze_pid" 2>/dev/null
    echo "$region"
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
    region=$(freeze_and_select -o)
    if [ -n "$region" ]; then
      grim -g "$region" - | satty --filename - --output-filename "$SCREENSHOT_FILE"
    fi
    ;;
  a)
    prepare_env
    grim - | satty --filename - --output-filename "$SCREENSHOT_FILE" --fullscreen all
    ;;
  o)
    region=$(freeze_and_select)
    if [ -n "$region" ]; then
      grim -g "$region" "$TEMP_OCR_FILE"
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
    else
      notify-send -u low "OCR Cancelled" "No area selected"
    fi
    ;;
  *)
    print_usage
    ;;
  esac
''
