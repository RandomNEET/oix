{ pkgs, opts, ... }:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  defaultTheme = if hasThemes then builtins.head opts.themes else "default";
in
pkgs.writeShellScriptBin "clip-manager" ''
  THEME_BASE_NAME="${defaultTheme}"
  PALETTE_FILE="$XDG_CONFIG_HOME/stylix/palette.json"
  if [ -f "$PALETTE_FILE" ]; then
    FULL_SLUG=$(${pkgs.jq}/bin/jq -r '.slug // empty' "$PALETTE_FILE")
    if [ -n "$FULL_SLUG" ]; then
      MODIFIERS="dark|light|hard|soft|medium|dim|high|low|storm|moon|night|latte|frappe|macchiato|mocha|pro|soda|classic|reloaded|alt|alternate|pale|tints|256"
      CLEANED_NAME="$FULL_SLUG"
      while [[ "$CLEANED_NAME" =~ -($MODIFIERS)$ ]]; do
        CLEANED_NAME=$(echo "$CLEANED_NAME" | sed -E "s/-($MODIFIERS)$//")
      done
      THEME_BASE_NAME="$CLEANED_NAME"
    fi
  fi
  THEME_BASE_NAME=''${THEME_BASE_NAME:-"${defaultTheme}"}

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
