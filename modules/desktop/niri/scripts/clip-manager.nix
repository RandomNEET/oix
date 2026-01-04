{
  config,
  lib,
  pkgs,
  ...
}:
let
  fullThemeName = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme);
  splitName = lib.splitString "-" fullThemeName;
  themeBaseName = builtins.head splitName;
in
pkgs.writeShellScript "clip-manager" ''
  while true; do
    result=$(
      rofi -dmenu \
        -kb-custom-1 "Control-Delete" \
        -kb-custom-2 "Alt-Delete" \
        -theme $HOME/.config/rofi/themes/${themeBaseName}/clip-manager.rasi < <(cliphist list)
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
