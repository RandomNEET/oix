{
  config,
  pkgs,
  mylib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  defaultTheme = builtins.head opts.themes;
  themeBaseName = if hasThemes then mylib.theme.getBaseName defaultTheme else "default";
  wallpaperDir = opts.wallpaper.dir or "${config.xdg.userDirs.pictures}/wallpapers";
in
pkgs.writeShellScript "restore-wall-theme" ''
  WALLPAPER_CONF="$HOME/.cache/noctalia/wallpapers.json"
  if [ ! -f "$WALLPAPER_CONF" ]; then
    echo "Error: $WALLPAPER_CONF not found."
    exit 1
  fi
  NEW_JSON=$(${pkgs.jq}/bin/jq --arg theme "${themeBaseName}" '
    .wallpapers |= map_values(
      gsub("${wallpaperDir}/[^/]+/"; "${wallpaperDir}/" + $theme + "/")
    )
  ' "$WALLPAPER_CONF")
  echo "$NEW_JSON" > "$WALLPAPER_CONF"
''
