{
  config,
  pkgs,
  opts,
  ...
}:
let
  hasThemes = opts ? themes;
  defaultTheme = if hasThemes then builtins.head opts.themes else "original";
  wallpaperDir = opts.wallpaper.dir or "${config.xdg.userDirs.pictures}/wallpapers";
in
pkgs.writeShellScript "restore-wall-theme" ''
  WALLPAPER_CONF="$HOME/.cache/noctalia/wallpapers.json"
  if [ -f "$WALLPAPER_CONF" ]; then
    NEW_JSON=$(jq --arg theme "${defaultTheme}" '
      def get_target_path: 
        if $theme == "original" 
        then "original" 
        else "themed/" + $theme 
        end;

      .wallpapers |= map_values(
        gsub("${wallpaperDir}/[^/]+(/[^/]+)?/"; "${wallpaperDir}/" + get_target_path + "/")
      )
    ' "$WALLPAPER_CONF")
    
    echo "$NEW_JSON" > "$WALLPAPER_CONF"
  fi
''
