#!/usr/bin/env bash
# For each display, changes the wallpaper to a randomly chosen image based on
# display orientation (landscape/portrait).

# Default configuration
DEFAULT_LANDSCAPE_DIR="$HOME/pic/wallpapers/landscape"
DEFAULT_PORTRAIT_DIR="$HOME/pic/wallpapers/portrait"
DEFAULT_TRANSITION_OPTS="--transition-type wipe --transition-duration 1 --transition-fps 60 --transition-step 90"

# Use provided arguments or defaults
LANDSCAPE_DIR="${1:-$DEFAULT_LANDSCAPE_DIR}"
PORTRAIT_DIR="${2:-$DEFAULT_PORTRAIT_DIR}"
TRANSITION_OPTS="${3:-$DEFAULT_TRANSITION_OPTS}"

# Validate directories
if [ ! -d "$LANDSCAPE_DIR" ] || [ ! -d "$PORTRAIT_DIR" ]; then
	printf "Error: Invalid directories\n"
	printf "  Landscape: %s\n" "$LANDSCAPE_DIR"
	printf "  Portrait: %s\n" "$PORTRAIT_DIR"
	printf "\nUsage:\n\t\e[1m%s\e[0m [\e[4mLANDSCAPE_DIR\e[0m] [\e[4mPORTRAIT_DIR\e[0m] [\e[4mTRANSITION_OPTS\e[0m]\n" "$0"
	printf "\nDefaults:\n"
	printf "  Landscape: %s\n" "$DEFAULT_LANDSCAPE_DIR"
	printf "  Portrait: %s\n" "$DEFAULT_PORTRAIT_DIR"
	printf "  Transition: %s\n" "$DEFAULT_TRANSITION_OPTS"
	exit 1
fi

# See swww-img(1)
RESIZE_TYPE="crop"

# Get display orientation (landscape or portrait)
get_orientation() {
	local display="$1"
	local line=$(swww query | grep ": $display:")
	local resolution=$(echo "$line" | sed -n 's/.*: [^:]*: \([0-9]*x[0-9]*\).*/\1/p')
	local width=$(echo "$resolution" | cut -d'x' -f1)
	local height=$(echo "$resolution" | cut -d'x' -f2)

	if [ -n "$width" ] && [ -n "$height" ] && [ "$width" -ge "$height" ] 2>/dev/null; then
		echo "landscape"
	else
		echo "portrait"
	fi
}

# Get random image from directory
get_random_image() {
	local dir="$1"
	find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1
}

# Parse swww query output and process each display
swww query | grep "^:" | while IFS= read -r line; do
	d=$(echo "$line" | sed -n 's/^: \([^:]*\):.*/\1/p')

	if [ -z "$d" ]; then
		continue
	fi

	orientation=$(get_orientation "$d")

	if [ "$orientation" = "landscape" ]; then
		img=$(get_random_image "$LANDSCAPE_DIR")
	else
		img=$(get_random_image "$PORTRAIT_DIR")
	fi

	if [ -n "$img" ] && [ -f "$img" ]; then
		if [ -n "$TRANSITION_OPTS" ]; then
			eval swww img --resize "$RESIZE_TYPE" --outputs "$d" $TRANSITION_OPTS '"$img"'
		else
			swww img --resize "$RESIZE_TYPE" --outputs "$d" "$img"
		fi
		echo "Set $orientation wallpaper for display $d: $img"
	else
		echo "Warning: No valid image found for $orientation display $d"
	fi
done
