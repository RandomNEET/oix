{
  config,
  pkgs,
  opts,
  ...
}:
let
  wallpaperDir =
    opts.wallpaper.dir
      or "${config.home-manager.users.${opts.users.primary.name}.xdg.userDirs.pictures}/wallpapers";
  landscapeDir = opts.wallpaper.landscapeDir or "${wallpaperDir}/landscape";
  portraitDir = opts.wallpaper.portraitDir or "${wallpaperDir}/portrait";
  transitionType = opts.wallpaper.transition.random-wall.type or "wipe";
  transitionStep = toString (opts.wallpaper.transition.random-wall.step or 90);
  transitionDuration = toString (opts.wallpaper.transition.random-wall.duration or 1);
  transitionFps = toString (opts.wallpaper.transition.random-wall.fps or 60);
in
pkgs.writeShellApplication {
  name = "random-wall";
  runtimeInputs = with pkgs; [
    swww
    coreutils
    findutils
    gnugrep
    gnused
  ];
  text = ''
    WAYLAND_SOCKET=$(find /run/user/$UID -maxdepth 1 -type s -name 'wayland-*' | head -n1)

    if [ -z "$WAYLAND_SOCKET" ]; then
    	exit 0
    fi

    DEFAULT_LANDSCAPE_DIR="${landscapeDir}"
    DEFAULT_PORTRAIT_DIR="${portraitDir}"
    DEFAULT_TRANSITION_OPTS="--transition-type ${transitionType} --transition-step ${transitionStep} --transition-duration ${transitionDuration} --transition-fps ${transitionFps}"

    LANDSCAPE_DIR="''${1:-$DEFAULT_LANDSCAPE_DIR}"
    PORTRAIT_DIR="''${2:-$DEFAULT_PORTRAIT_DIR}"
    TRANSITION_OPTS="''${3:-$DEFAULT_TRANSITION_OPTS}"

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

    RESIZE_TYPE="crop"

    get_orientation() {
    	local display="$1"
    	local line 
    	line=$(swww query | grep ": $display:")
    	local resolution
    	resolution=$(echo "$line" | sed -n 's/.*: [^:]*: \([0-9]*x[0-9]*\).*/\1/p')
    	local width
    	width=$(echo "$resolution" | cut -d'x' -f1)
    	local height
    	height=$(echo "$resolution" | cut -d'x' -f2)

    	if [ -n "$width" ] && [ -n "$height" ] && [ "$width" -ge "$height" ] 2>/dev/null; then
    		echo "landscape"
    	else
    		echo "portrait"
    	fi
    }

    get_random_image() {
    	local dir="$1"
    	find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1
    }

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
    			eval swww img --resize "$RESIZE_TYPE" --outputs "$d" "$TRANSITION_OPTS" "$img"
    		else
    			swww img --resize "$RESIZE_TYPE" --outputs "$d" "$img"
    		fi
    		echo "Set $orientation wallpaper for display $d: $img"
    	else
    		echo "Warning: No valid image found for $orientation display $d"
    	fi
    done
  '';
}
