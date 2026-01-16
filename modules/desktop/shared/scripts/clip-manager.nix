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
  themeBaseName = if hasThemes then mylib.theme.getBaseName config.stylix.base16Scheme else "default";
in
pkgs.writeShellScriptBin "clip-manager" ''
  THEME_BASE_NAME="${themeBaseName}"

  while true; do
    result=$(
      rofi -dmenu \
        -kb-custom-1 "Control-Delete" \
        -kb-custom-2 "Alt-Delete" \
        -theme $HOME/.config/rofi/themes/$THEME_BASE_NAME/clip-manager.rasi < <(cliphist list)
    )

    case "$?" in
    1)
      exit
      ;;
    0)
      case "$result" in
      "")
        continue
        ;;
      *)
        cliphist decode <<<"$result" | wl-copy
        exit
        ;;
      esac
      ;;
    10)
      cliphist delete <<<"$result"
      ;;
    11)
      cliphist wipe
      ;;
    esac
  done
''
