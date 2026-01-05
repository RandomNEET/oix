{
  lib,
  pkgs,
  opts,
  ...
}:
let
  wallpaperDir = opts.wallpaper.dir;
  originalDir = "${wallpaperDir}/default";

  themeBaseNames = map (t: builtins.head (lib.splitString "-" t)) opts.themes;
  uniqueThemes = lib.unique themeBaseNames;
  themesArray = lib.concatStringsSep " " (map (t: ''"${t}"'') uniqueThemes);
in
pkgs.writeShellScript "convert-wall" ''
  ORIGINAL_DIR="${originalDir}"
  WALLPAPERS_DIR="${wallpaperDir}"
  THEMES=(${themesArray})

  if [ ! -d "$ORIGINAL_DIR" ]; then
    echo "Error: Source directory $ORIGINAL_DIR not found."
    exit 1
  fi

  for THEME in "''${THEMES[@]}"; do
    for ORIENT in "landscape" "portrait"; do
      SRC_ORIENT="$ORIGINAL_DIR/$ORIENT"
      [ -d "$SRC_ORIENT" ] || continue

      for CAT_PATH in "$SRC_ORIENT"/*; do
        [ -d "$CAT_PATH" ] || continue
        CAT_NAME=$(basename "$CAT_PATH")

        TARGET_DIR="$WALLPAPERS_DIR/$THEME/$ORIENT/$CAT_NAME"
        mkdir -p "$TARGET_DIR"

        echo "--- Processing: [$THEME] -> [$ORIENT] -> [$CAT_NAME] ---"

        for img in "$CAT_PATH"/*; do
          [[ -f "$img" ]] || continue
          IMG_NAME=$(basename "$img")

          # Available formats:  png, jpg, jpeg, webp
          if [[ ! "$IMG_NAME" =~ \.(png|jpg|jpeg|webp)$ ]]; then
            continue
          fi

          if [ -f "$TARGET_DIR/$IMG_NAME" ]; then
            continue
          fi

          # Call gowall for color conversion
          ${pkgs.gowall}/bin/gowall convert "$img" \
            --theme "$THEME" \
            --output "$TARGET_DIR/$IMG_NAME"
        done
      done
    done
  done

  echo "All conversion tasks completed successfully!"
''
