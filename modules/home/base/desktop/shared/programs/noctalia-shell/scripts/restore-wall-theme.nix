{
  config,
  pkgs,
  ...
}:
let
  hasThemes = config.desktop.themes.enable;
  defaultTheme = if hasThemes then builtins.head config.desktop.themes.list else "original";
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
        gsub("${config.desktop.wallpaper.dir}/[^/]+(/[^/]+)?/"; "${config.desktop.wallpaper.dir}/" + get_target_path + "/")
      )
    ' "$WALLPAPER_CONF")
    
    echo "$NEW_JSON" > "$WALLPAPER_CONF"
  fi
''
