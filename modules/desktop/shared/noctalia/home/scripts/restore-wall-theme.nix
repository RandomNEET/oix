{
  osConfig,
  config,
  pkgs,
  ...
}:
let
  defaultTheme =
    if (osConfig.oix.appearance.themes.enable or false) then
      builtins.head (osConfig.oix.appearance.themes.list or [ ])
    else
      "original";
in
pkgs.writeShellScript "restore-wallpaper-settings" ''
  SETTINGS_FILE="/home/howl/.local/state/noctalia/settings.toml"

  if [ "$(echo '${defaultTheme}')" = "original" ]; then
    TARGET="original"
  else
    TARGET="themed/${defaultTheme}"
  fi

  DIR="${config.oix.desktop.wallpaper.dir}"
  ESC_DIR=$(printf '%s\n' "$DIR" | sed 's:[][\/.^$*]:\\&:g')
  ESC_TARGET=$(printf '%s\n' "$TARGET" | sed 's:[][\/.^$*]:\\&:g')

  sed -i -E "\|^(path = \")''${ESC_DIR}/[^/]+(/[^/]+)?(.*)\"$| s||\1''${ESC_DIR}/''${ESC_TARGET}\3\"|" "$SETTINGS_FILE"
  awk -i inplace '/^\[theme\]\s*$/{skip=1; next} /^\[/{skip=0} !skip' "$SETTINGS_FILE"
''
