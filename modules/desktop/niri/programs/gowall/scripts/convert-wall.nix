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

  if [ !  -d "$ORIGINAL_DIR" ]; then
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

        IMAGES_TO_CONVERT=""
        for img in "$CAT_PATH"/*; do
          [[ -f "$img" ]] || continue
          IMG_NAME=$(basename "$img")
          [[ "$IMG_NAME" =~ \.(png|jpg|jpeg|webp)$ ]] || continue
          [ -f "$TARGET_DIR/$IMG_NAME" ] && continue
          IMAGES_TO_CONVERT="$IMAGES_TO_CONVERT,$img"
        done

        IMAGES_TO_CONVERT="''${IMAGES_TO_CONVERT#,}"
        if [ -n "$IMAGES_TO_CONVERT" ]; then
          echo "--- Processing: [$THEME] -> [$ORIENT] -> [$CAT_NAME] ---"
          ${pkgs.gowall}/bin/gowall convert \
            --batch "$IMAGES_TO_CONVERT" \
            --theme "$THEME" \
            --output "$TARGET_DIR"
        fi
      done
    done
  done

  echo "All conversion tasks completed successfully!"
''
