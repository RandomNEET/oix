{ config, pkgs, ... }:
pkgs.writeShellScriptBin "screenshot-handler" ''
  XDG_PICTURES_DIR="${config.xdg.userDirs.pictures}"
  SCREENSHOT_DIR="$XDG_PICTURES_DIR/screenshots"
  OCR_LANGS="eng+chi_sim+chi_tra"
  SIGNAL_FILE="/tmp/noctalia-screenshot-ocr"

  mkdir -p "$SCREENSHOT_DIR"

  if [ -f "$SIGNAL_FILE" ]; then
      MODE="ocr"
      rm -f "$SIGNAL_FILE"
  else
      MODE="screenshot"
  fi

  if [ "$MODE" = "ocr" ]; then
      tmp="$(mktemp)"
      cat > "$tmp"
      text="$(tesseract "$tmp" stdout -l "$OCR_LANGS" 2>/dev/null)"
      rm -f "$tmp"
      if [ -n "$text" ]; then
          echo -n "$text" | wl-copy
          notify-send -a screenshot -u low -i edit-paste "OCR Success" "Text copied"
      else
          notify-send -a screenshot -u low -i dialog-error "OCR Failed" "No text recognized"
      fi
  else
      output="$SCREENSHOT_DIR/screenshot-$(date +'%Y-%m-%d-%H:%M:%S').png"
      satty --filename - --output-filename "$output"
  fi
''
