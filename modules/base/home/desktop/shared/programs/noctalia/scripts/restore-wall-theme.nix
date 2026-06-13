{
  osConfig,
  config,
  pkgs,
  ...
}:
let
  defaultTheme =
    if osConfig.desktop.themes.enable then builtins.head osConfig.desktop.themes.list else "original";
in
pkgs.writeShellScript "restore-wallpaper-settings" ''
  SETTINGS_FILE="/home/howl/.local/state/noctalia/settings.toml"

  if [ "$(echo '${defaultTheme}')" = "original" ]; then
    TARGET="original"
  else
    TARGET="themed/${defaultTheme}"
  fi

  DIR="${config.desktop.wallpaper.dir}"
  ESC_DIR=$(printf '%s\n' "$DIR" | sed 's:[][\/.^$*]:\\&:g')
  ESC_TARGET=$(printf '%s\n' "$TARGET" | sed 's:[][\/.^$*]:\\&:g')

  sed -i -E "\|^(path = \")''${ESC_DIR}/[^/]+(/[^/]+)?(.*)\"$| s||\1''${ESC_DIR}/''${ESC_TARGET}\3\"|" "$SETTINGS_FILE"
  awk -i inplace '/^\[theme\]\s*$/{skip=1; next} /^\[/{skip=0} !skip' "$SETTINGS_FILE"
''
