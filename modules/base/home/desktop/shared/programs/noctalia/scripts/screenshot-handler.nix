{ pkgs, ... }:
pkgs.writeShellScriptBin "screenshot-handler" ''
  OCR_LANGS="eng+chi_sim+chi_tra"
  SIGNAL_FILE="/tmp/noctalia-screenshot-ocr"

  if [ -f "$SIGNAL_FILE" ]; then
      rm -f "$SIGNAL_FILE"
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
  fi
''
