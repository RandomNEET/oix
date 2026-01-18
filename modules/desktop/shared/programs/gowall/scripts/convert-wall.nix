{
  pkgs,
  mylib,
  opts,
  ...
}:
let
  wallpaperDir = opts.wallpaper.dir;
  originalDir = "${wallpaperDir}/default";

  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  # Available: arcdark atomdark cat-frappe cat-latte catppuccin cyberpunk dracula everforest github-light gruvbox kanagawa material melange-dark melange-light monokai night-owl nord oceanic-next onedark palenight rose-pine shades-of-purple solarized srcery sunset-aurant sunset-saffron sunset-tangerine synthwave-84 tokyo-dark tokyo-moon tokyo-storm
  # Custom: tokyo-night
  themesArray = mylib.theme.getThemesArray themes;
in
if hasThemes then
  pkgs.writeShellScript "convert-wall" ''
    # --- 1. CONFIGURATION & INITIALIZATION ---
    ORIGINAL_DIR="${originalDir}"
    WALLPAPERS_DIR="${wallpaperDir}"
    THEMES=(${themesArray})

    if [ ! -d "$ORIGINAL_DIR" ]; then
      echo "Error: Source directory $ORIGINAL_DIR not found."
      exit 1
    fi

    # --- 2. CLEANUP: STALE THEME DIRECTORIES  ---
    for DIR_PATH in "$WALLPAPERS_DIR"/*; do
      [ -d "$DIR_PATH" ] || continue
      DIR_NAME=$(basename "$DIR_PATH")

      [ "$DIR_NAME" == "default" ] && continue

      IS_STALE=true
      for T in "''${THEMES[@]}"; do
        if [ "$T" == "$DIR_NAME" ]; then
          IS_STALE=false
          break
        fi
      done

      if [ "$IS_STALE" == "true" ]; then
        echo "Cleanup: Removing stale theme directory -> $DIR_NAME"
        rm -rf "$DIR_PATH"
      fi
    done

    # --- 3. THEME ITERATION ---
    for THEME in "''${THEMES[@]}"; do
      [ "$THEME" == "default" ] && continue
      
      THEME_ROOT="$WALLPAPERS_DIR/$THEME"
      echo "=== Syncing Theme: [$THEME] ==="

      # --- 4. ORIENTATION LOOP (landscape/portrait) ---
      for ORIENT in "landscape" "portrait"; do
        SRC_ORIENT="$ORIGINAL_DIR/$ORIENT"
        TARGET_ORIENT="$THEME_ROOT/$ORIENT"

        if [ ! -d "$SRC_ORIENT" ]; then
          [ -d "$TARGET_ORIENT" ] && rm -rf "$TARGET_ORIENT"
          continue
        fi

        # --- 5. CLEANUP: STALE CATEGORIES ---
        if [ -d "$TARGET_ORIENT" ]; then
          for TARGET_CAT_PATH in "$TARGET_ORIENT"/*; do
            [ -d "$TARGET_CAT_PATH" ] || continue
            CAT_NAME=$(basename "$TARGET_CAT_PATH")
            
            if [ ! -d "$SRC_ORIENT/$CAT_NAME" ]; then
              echo "Cleaning up deleted category: $CAT_NAME"
              rm -rf "$TARGET_CAT_PATH"
            fi
          done
        fi

        # --- 6. CATEGORY SYNCING ---
        for CAT_PATH in "$SRC_ORIENT"/*; do
          [ -d "$CAT_PATH" ] || continue
          CAT_NAME=$(basename "$CAT_PATH")
          TARGET_DIR="$TARGET_ORIENT/$CAT_NAME"
          mkdir -p "$TARGET_DIR"

          # --- 6a. CLEANUP: STALE FILES ---
          for TARGET_FILE in "$TARGET_DIR"/*; do
            [[ -f "$TARGET_FILE" ]] || continue
            FILE_NAME=$(basename "$TARGET_FILE")
            
            if [ ! -f "$CAT_PATH/$FILE_NAME" ]; then
              echo "Deleting stale image: $TARGET_FILE"
              rm "$TARGET_FILE"
            fi
          done

          # --- 6b. INCREMENTAL CONVERSION ---
          IMAGES_TO_CONVERT=""
          for img in "$CAT_PATH"/*; do
            [[ -f "$img" ]] || continue
            IMG_NAME=$(basename "$img")
            
            # Only process valid image extensions
            [[ "$IMG_NAME" =~ \.(png|jpg|jpeg|webp)$ ]] || continue
            
            [ -f "$TARGET_DIR/$IMG_NAME" ] && continue
            
            IMAGES_TO_CONVERT="$IMAGES_TO_CONVERT,$img"
          done

          # Use gowall to convert the collected images in one batch for better performance
          IMAGES_TO_CONVERT="''${IMAGES_TO_CONVERT#,}" # Remove leading comma
          if [ -n "$IMAGES_TO_CONVERT" ]; then
            echo "Processing new images: [$THEME] -> [$ORIENT] -> [$CAT_NAME]"
            ${pkgs.gowall}/bin/gowall convert \
              --batch "$IMAGES_TO_CONVERT" \
              --theme "$THEME" \
              --output "$TARGET_DIR"
          fi
        done
      done
    done

    echo "Full synchronization and conversion completed successfully!"
  ''
else
  null
