{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) getExe;
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  defaultTheme = if hasThemes then builtins.head opts.themes else "default";
  themeReloadCommands = ''
    systemctl --user restart waybar
    systemctl --user restart fcitx5-daemon
    niri msg action reload-config
    ${random-wall}
  '';
  random-wall = getExe (import ./random-wall.nix { inherit config pkgs opts; });

  terminal = opts.terminal;
  displays = opts.display or [ ];
  wallpaperDir =
    opts.wallpaper.dir
      or "${config.home-manager.users.${opts.users.primary.name}.xdg.userDirs.pictures}/wallpapers";
  transitionType = opts.wallpaper.launcher.transition.type or "center";
  transitionStep = toString (opts.wallpaper.launcher.transition.step or 90);
  transitionDuration = toString (opts.wallpaper.launcher.transition.duration or 1);
  transitionFps = toString (opts.wallpaper.launcher.transition.fps or 60);

  displayCount = builtins.length displays;
  displayListStr = lib.concatMapStringsSep "\n" (
    idx:
    let
      display = builtins.elemAt displays idx;
    in
    "${toString (idx + 1)}: ${display.output} - ${toString display.width}x${toString display.height} (${display.orientation})"
  ) (lib.range 0 (displayCount - 1));
  displayCaseStr = lib.concatMapStringsSep "\n" (
    idx:
    let
      display = builtins.elemAt displays idx;
    in
    "${toString (idx + 1)})\n DISPLAY_OUTPUT=\"${display.output}\"\n DISPLAY_ORIENTATION=\"${display.orientation}\"\n ;;"
  ) (lib.range 0 (displayCount - 1));
  singleDisplayOutput = if displayCount == 1 then (builtins.elemAt displays 0).output else "";
  singleDisplayOrientation =
    if displayCount == 1 then (builtins.elemAt displays 0).orientation else "";
in
pkgs.writeShellScriptBin "launcher" ''
  if pidof rofi >/dev/null; then
    pkill rofi
    exit 0
  fi

  THEME_BASE_NAME="${defaultTheme}"
  PALETTE_FILE="$XDG_CONFIG_HOME/stylix/palette.json"
  if [ -f "$PALETTE_FILE" ]; then
    FULL_SLUG=$(${pkgs.jq}/bin/jq -r '.slug // empty' "$PALETTE_FILE")
    if [ -n "$FULL_SLUG" ]; then
      THEME_BASE_NAME=$(echo "$FULL_SLUG" | cut -d'-' -f1)
    fi
  fi
  THEME_BASE_NAME=''${THEME_BASE_NAME:-"${defaultTheme}"}

  case $1 in
  drun)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/drun.rasi"
    r_override="entry{placeholder:'Search...';}listview{lines:9;}"
    rofi -show drun -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  window)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/window.rasi"
    r_override="entry{placeholder:'Search Windows...';}listview{lines:12;}"
    rofi -show window -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  file)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/file.rasi"
    r_override="entry{placeholder:'Search Files...';}listview{lines:8;}"
    rofi -show filebrowser -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  game)
    r_override="entry{placeholder:'Search Games...';}listview{lines:15;}"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/game.rasi"
    rofi -show games -modi games -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  emoji)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/emoji.rasi"
    r_override="entry{placeholder:'Search Emojis...';}listview{lines:15;}"
    rofi -modi emoji -show emoji -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  rbw)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/rbw.rasi"
    rofi-rbw --selector rofi --selector-args="-theme $rofi_theme"
    ;;
  tmux)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/tmux.rasi"
    r_override="entry{placeholder:'Search Tmux Sessions...';}listview{lines:15;}"
    sessions=$(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' |
      rofi -dmenu -i -theme-str "$r_override" -theme "$rofi_theme" | cut -d: -f1)
    if [[ $sessions ]]; then
      ${terminal} --hold -e tmux attach -t $sessions
    fi
    ;;
  wallpaper)
    WALLPAPER_DIR="${wallpaperDir}"
    LANDSCAPE_DIR="$WALLPAPER_DIR/$THEME_BASE_NAME/landscape"
    PORTRAIT_DIR="$WALLPAPER_DIR/$THEME_BASE_NAME/portrait"
    DISPLAY_COUNT=${toString displayCount}

    if [ "$DISPLAY_COUNT" -eq 1 ]; then
      DISPLAY_OUTPUT="${singleDisplayOutput}"
      DISPLAY_ORIENTATION="${singleDisplayOrientation}"
    else
      rofi_theme_display="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/wallpaper-display.rasi"
      r_override_display="entry{placeholder:'Select Display...';}listview{lines:$DISPLAY_COUNT;}"

      DISPLAY_CHOICE=$(rofi -dmenu \
        -i \
        -theme-str "$r_override_display" \
        -theme "$rofi_theme_display" \
        -format 'i:s' <<< "${displayListStr}")

      [ -z "$DISPLAY_CHOICE" ] && exit 0

      TARGET_DISPLAY=$(echo "$DISPLAY_CHOICE" | cut -d':' -f2 | cut -d':' -f1 | tr -d ' ')
      case "$TARGET_DISPLAY" in
        ${displayCaseStr}
        *)
          echo "Invalid display selection"
          exit 1
          ;;
      esac
    fi

    CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-thumbnails"

    if [ -d "$CACHE_DIR" ]; then
      find "$CACHE_DIR" -type f -name "*.jpg" | while read -r thumb; do
        rel_thumb="''${thumb#$CACHE_DIR/}"
        source_base="$WALLPAPER_DIR/''${rel_thumb%.*}"
        
        found=false
        for ext in jpg jpeg png webp jxl gif; do
          if [ -f "$source_base.$ext" ]; then
            found=true
            break
          fi
        done

        if [ "$found" = false ]; then
          echo "Removing stale thumbnail: $rel_thumb"
          rm "$thumb"
          rmdir -p "$(dirname "$thumb")" 2>/dev/null || true
        fi
      done
    fi

    if [ "$DISPLAY_ORIENTATION" = "landscape" ]; then
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/wallpaper-landscape.rasi"
      SEARCH_DIR="$LANDSCAPE_DIR"
      THUMB_SIZE="320x180"
    else
      rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/wallpaper-portrait.rasi"
      SEARCH_DIR="$PORTRAIT_DIR"
      THUMB_SIZE="180x320"
    fi

    r_override="entry{placeholder:'Search Wallpapers for $DISPLAY_OUTPUT ($DISPLAY_ORIENTATION)...';}"

    generate_thumbnail() {
      local wallpaper="$1"
      local thumb_size="$2"
      local relative_path="''${wallpaper#$WALLPAPER_DIR/}"
      local wallpaper_name="''${relative_path%.*}"
      local thumbnail="$CACHE_DIR/''${wallpaper_name}.jpg"
      mkdir -p "$(dirname "$thumbnail")"
      ${getExe pkgs.imagemagick} "$wallpaper[0]" \
        -strip -gravity center \
        -thumbnail "$thumb_size^" \
        -extent "$thumb_size" \
        "$thumbnail" 2>/dev/null || true
    }
    
    MISSING_THUMBS=()
    while read -r wallpaper; do
      relative_path="''${wallpaper#$WALLPAPER_DIR/}"
      wallpaper_name="''${relative_path%.*}"
      thumbnail="$CACHE_DIR/''${wallpaper_name}.jpg"
      if [ !  -f "$thumbnail" ]; then
        MISSING_THUMBS+=("$wallpaper")
      fi
    done < <(${getExe pkgs.fd} --type f \
      -e jpg -e jpeg -e png -e webp -e jxl -e gif \
      . "$SEARCH_DIR")
    
    if [ ''${#MISSING_THUMBS[@]} -gt 0 ]; then
      mkdir -p "$CACHE_DIR"
      for wallpaper in "''${MISSING_THUMBS[@]}"; do
        generate_thumbnail "$wallpaper" "$THUMB_SIZE" &
        (( $(jobs -r | wc -l) >= 4 )) && wait -n
      done
      wait
    fi

    CHOICE=$(${getExe pkgs.fd} --type f \
      -e jpg -e jpeg -e png -e webp -e jxl -e gif \
      . "$SEARCH_DIR" \
      | sed "s|$WALLPAPER_DIR/||" \
      | while read -r A; do
          thumb_path="''${A%.*}.jpg"
          echo -en "$A\x00icon\x1f$CACHE_DIR/$thumb_path\n"
        done \
      | rofi -dmenu \
        -i \
        -theme-str "$r_override" \
        -theme "$rofi_theme")

    [ -z "$CHOICE" ] && exit 0

    WALLPAPER_PATH="$WALLPAPER_DIR/$CHOICE"

    swww img --outputs "$DISPLAY_OUTPUT" "$WALLPAPER_PATH" \
      --transition-type "${transitionType}" \
      --transition-step "${transitionStep}" \
      --transition-duration "${transitionDuration}" \
      --transition-fps "${transitionFps}"

    echo "Set wallpaper for Display $DISPLAY_OUTPUT ($DISPLAY_ORIENTATION): $WALLPAPER_PATH"
    ;;
  theme)
    BASE_GEN="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"
    SPEC_DIR="$BASE_GEN/specialisation"
    
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/theme.rasi"
    r_override="entry{placeholder:'Select Theme...';}listview{lines:9;}"
    
    SELECTED=$( (ls "$SPEC_DIR" 2>/dev/null; echo "${defaultTheme}") | \
        rofi -dmenu -i -p "Theme" -theme-str "$r_override" -theme "$rofi_theme")
    
    if [ -z "$SELECTED" ]; then
      exit 0
    fi
    
    if [ "$SELECTED" = "${defaultTheme}" ]; then
      echo "Switching to $SELECTED..."
      "$BASE_GEN/activate"
    else
      echo "Switching to $SELECTED..."
      "$SPEC_DIR/$SELECTED/activate"
    fi
    
    ${themeReloadCommands}
    ;;
  spec)
    SPEC_DIR="/nix/var/nix/profiles/system/specialisation"
    SYSTEM_SWITCH="/nix/var/nix/profiles/system/bin/switch-to-configuration"

    OPTIONS="default"
    if [ -d "$SPEC_DIR" ]; then
      OPTIONS="$OPTIONS\n$(ls "$SPEC_DIR")"
    fi

    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/$THEME_BASE_NAME/specialisation.rasi"
    r_override="entry{placeholder:'Select Specialisation...';}listview{lines:9;}"
    
    SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Theme" -theme-str "$r_override" -theme "$rofi_theme")

    if [ -z "$SELECTED" ]; then
      exit 0
    fi

    if [ "$SELECTED" = "default" ]; then
      pkexec "$SYSTEM_SWITCH" test
    else
      pkexec "$SPEC_DIR/$SELECTED/bin/switch-to-configuration" test
    fi
    ;;
  help | --help | -h)
    echo "Usage: launcher [ACTION]"
    echo "Launch various rofi modes with custom themes and settings."
    echo ""
    echo "Actions:"
    echo "  drun                   Launch application search mode"
    echo "  window                 Switch between open windows"
    echo "  file                   Browse and search files"
    echo "  game                   Launch games menu"
    echo "  emoji                  Search and insert emojis"
    echo "  rbw                    Browse and search passwords"
    echo "  tmux                   Search active tmux sessions"
    echo "  wallpaper              Select display and set wallpaper"
    echo "  theme                  Select and set theme"
    echo "  spec                   Select and switch specialisation "
    echo "  help                   Display this help message"
    echo "  --help                 Same as 'help'"
    echo ""
    echo "If no action is specified, defaults to 'drun' mode."
    exit 0
    ;;
  *)
    exec "$0" drun
    ;;
  esac
''
