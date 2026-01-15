#!/usr/bin/env bash

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/pic}"

SWAPPY_CONF_DIR="$XDG_CONFIG_HOME/swappy"
SCREENSHOT_DIR="$XDG_PICTURES_DIR/screenshots"
TEMP_OCR_FILE="/tmp/ocr_screenshot.png"

prepare_env() {
	mkdir -p "$SCREENSHOT_DIR" "$SWAPPY_CONF_DIR"
	local timestamp
	timestamp=$(date +'%y%m%d_%Hh%Mm%Ss')
	local filename="${timestamp}_screenshot.png"

	cat <<EOF >"$SWAPPY_CONF_DIR/config"
[Default]
save_dir=$SCREENSHOT_DIR
save_filename_format=$filename
EOF
}

check_dependencies() {
	local deps=(grimblast swappy notify-send gowall tesseract wl-copy)
	for cmd in "${deps[@]}"; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			echo "Error: Required command '$cmd' not found."
			exit 1
		fi
	done
}

print_usage() {
	cat <<EOF
Usage: $(basename "$0") <action>
Actions:
  p  : Fullscreen capture (all screens)
  s  : Area capture (interactive)
  sf : Area capture (frozen screen)
  m  : Focused monitor capture
  o  : OCR capture (area to clipboard)
EOF
	exit 1
}

check_dependencies

case "$1" in
p)
	prepare_env
	grimblast save screen - | swappy -f -
	;;
s)
	prepare_env
	grimblast save area - | swappy -f -
	;;
sf)
	prepare_env
	grimblast --freeze save area - | swappy -f -
	;;
m)
	prepare_env
	grimblast save output - | swappy -f -
	;;
o)
	if grimblast --freeze save area "$TEMP_OCR_FILE"; then
		if gowall ocr "$TEMP_OCR_FILE" - -s tes | wl-copy; then
			notify-send -a "screenshot" -u low -i "edit-paste" "OCR Success" "Text copied to clipboard"
		else
			notify-send -a "screenshot" -u low -i "dialog-error" "OCR Error" "Failed to recognize text"
		fi
		rm -f "$TEMP_OCR_FILE"
	else
		notify-send "OCR Cancelled" "No area selected"
	fi
	;;
*)
	print_usage
	;;
esac

latest_file=$(find "$SCREENSHOT_DIR" -name "*_screenshot.png" -cmin -0.1 2>/dev/null | head -n 1)
if [[ -n "$latest_file" ]]; then
	notify-send -a "screenshot" -u low -r 91190 -t 2200 -i "$latest_file" "Screenshot Saved" "Path: $SCREENSHOT_DIR"
fi
