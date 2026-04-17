{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasThemes = config.desktop.themes.enable;
  defaultTheme = if hasThemes then builtins.head config.desktop.themes.list else "default";
  terminal = (import ../misc/terminal.nix { inherit config; }).exe;
in
pkgs.writeShellScriptBin "launcher" ''
  if pidof rofi >/dev/null; then
    pkill rofi
    exit 0
  fi

  case $1 in
  drun)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/drun.rasi"
    r_override="entry{placeholder:'Search...';}listview{lines:9;}"
    rofi -show drun -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  window)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/window.rasi"
    r_override="entry{placeholder:'Search Windows...';}listview{lines:12;}"
    rofi -show window -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  file)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/file.rasi"
    r_override="entry{placeholder:'Search Files...';}listview{lines:8;}"
    rofi -show filebrowser -theme-str "$r_override" -theme "$rofi_theme"
    ;;
  game)
    r_override="entry{placeholder:'Search Games...';}listview{lines:15;}"
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/game.rasi"
    rofi -show games -modi games -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  emoji)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/emoji.rasi"
    r_override="entry{placeholder:'Search Emojis...';}listview{lines:15;}"
    rofi -modi emoji -show emoji -theme "''${rofi_theme}" -theme-str "$r_override"
    ;;
  rbw)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/rbw.rasi"
    rofi-rbw --selector rofi --selector-args="-theme $rofi_theme"
    ;;
  tmux)
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/tmux.rasi"
    r_override="entry{placeholder:'Search Tmux Sessions...';}listview{lines:15;}"
    sessions=$(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' |
      rofi -dmenu -i -theme-str "$r_override" -theme "$rofi_theme" | cut -d: -f1)
    if [[ $sessions ]]; then
      ${terminal} --hold -e tmux attach -t $sessions
    fi
    ;;
  translate)
  rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/translate.rasi"
    display_result=""

    while true; do
      if [[ -z "$display_result" ]]; then
        query=$(rofi -dmenu -p " " \
          -theme "$rofi_theme" \
          -theme-str 'mainbox{children:[inputbar];}')
      else
        query=$(rofi -dmenu -p " " \
          -mesg "$display_result" \
          -theme "$rofi_theme" \
          -theme-str 'mainbox{children:[inputbar,message];} textbox{margin:0px 0px 30px 0px;}')
      fi

      [[ -z "$query" ]] && break

      rofi -dmenu -p " " \
        -mesg "Translating: $query" \
        -theme "$rofi_theme" \
        -theme-str 'mainbox{children:[inputbar,message];}' \
        < /dev/null > /dev/null 2>&1 &
      
      loading_pid=$!

      if [[ "$query" =~ ^([a-zA-Z-]*:[a-zA-Z-]+)[[:space:]]+(.*)$ ]]; then
        lang_pair="''${BASH_REMATCH[1]}"
        text_to_trans="''${BASH_REMATCH[2]}"
        result=$(trans -v -no-ansi \
        -show-translation n \
        -show-translation-phonetics n \
        -show-prompt-message n \
        -show-languages n \
        "$lang_pair" "$text_to_trans" 2>/dev/null)
      else
        result=$(trans -v -no-ansi \
        -show-translation n \
        -show-translation-phonetics n \
        -show-prompt-message n \
        -show-languages n \
        "$query" 2>/dev/null)
      fi

      kill $loading_pid 2>/dev/null
      wait $loading_pid 2>/dev/null

      if [[ -n "$result" ]]; then
        display_result="$result"
      else
        display_result="Translation failed."
      fi
    done
    ;;
  theme)
    BASE_GEN="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager-base"
    SPEC_DIR="$BASE_GEN/specialisation"
    
    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/theme.rasi"
    r_override="entry{placeholder:'Select Theme...';}listview{lines:9;}"
    
    SELECTED=$( (ls "$SPEC_DIR" 2>/dev/null; echo "${defaultTheme}") | \
        rofi -dmenu -i -p "Theme" -theme-str "$r_override" -theme "$rofi_theme")
    
    if [ -z "$SELECTED" ]; then
      exit 0
    fi
    
    notify-send -a "Theme Switcher" -u low -i "preferences-desktop-theme" "Switching to $SELECTED"

    if [ "$SELECTED" = "${defaultTheme}" ]; then
      "$BASE_GEN/activate"
    else
      "$SPEC_DIR/$SELECTED/activate"
    fi

    sleep 0.1

    ${lib.optionalString config.programs.tmux.enable ''
      if tmux ls > /dev/null 2>&1; then
        tmux source-file ${config.xdg.configHome}/tmux/tmux.conf
      fi
    ''} 
    ${lib.optionalString config.programs.nixvim.enable ''
      RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(${pkgs.coreutils}/bin/id -u)}"
      if pgrep -x "nvim" >/dev/null; then
        for server in "$RUNTIME_DIR"/nvim.*.0; do
          [ -e "$server" ] || continue
          pid=$(basename "$server" | cut -d. -f2)
          if kill -0 "$pid" 2>/dev/null; then
            nvim --server "$server" --remote-expr "execute('lua if _G.reload_theme then _G.reload_theme() end')" >/dev/null 2>&1 &
          else
            rm -f "$server"
          fi
        done
      fi
    ''} 
    ${lib.optionalString (config.programs ? noctalia-shell && config.programs.noctalia-shell.enable)
      ''
        ${lib.optionalString config.desktop.wallpaper.enable ''
          WALLPAPER_CONF="$HOME/.cache/noctalia/wallpapers.json"
          if [ -f "$WALLPAPER_CONF" ]; then
            NEW_JSON=$(jq --arg theme "$SELECTED" '
              def get_target_path: 
                if $theme == "original" 
                then "original" 
                else "themed/" + $theme 
                end;

              .wallpapers |= map_values(
                map_values(
                  gsub("${config.desktop.wallpaper.dir}/[^/]+(/[^/]+)?/"; "${config.desktop.wallpaper.dir}/" + get_target_path + "/")
                )
              )
            ' "$WALLPAPER_CONF")
            
            echo "$NEW_JSON" > "$WALLPAPER_CONF"
          fi
        ''}

        noctalia-shell kill
        for i in {1..20}; do 
            noctalia-shell list --all | grep -q "No running" && break || sleep 0.2
        done
        noctalia-shell -d

        systemctl --user restart fcitx5-daemon
      ''
    }
    ;;
  spec)
    SPEC_DIR="/nix/var/nix/profiles/system/specialisation"
    SYSTEM_SWITCH="/nix/var/nix/profiles/system/bin/switch-to-configuration"

    OPTIONS="default"
    if [ -d "$SPEC_DIR" ]; then
      OPTIONS="$OPTIONS\n$(ls "$SPEC_DIR")"
    fi

    rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/specialisation.rasi"
    r_override="entry{placeholder:'Select Specialisation...';}listview{lines:9;}"
    
    SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Theme" -theme-str "$r_override" -theme "$rofi_theme")

    if [ -z "$SELECTED" ]; then
      exit 0
    fi

    if [ "$SELECTED" = "default" ]; then
      pkexec "$SYSTEM_SWITCH" test
    else
      pkexec "$SPEC_DIR/$SELECTED/bin/switch-to-configuration" test
    fi
    ;;
  help | --help | -h)
    echo "Usage: launcher [ACTION]"
    echo "Launch various rofi modes with custom themes and settings."
    echo ""
    echo "Actions:"
    echo "  drun                   Launch application search mode"
    echo "  window                 Switch between open windows"
    echo "  file                   Browse and search files"
    echo "  game                   Launch games menu"
    echo "  emoji                  Search and insert emojis"
    echo "  rbw                    Browse and search passwords"
    echo "  tmux                   Search active tmux sessions"
    echo "  translate              Quick translator"
    echo "  theme                  Select and set theme"
    echo "  spec                   Select and switch specialisation "
    echo "  help                   Display this help message"
    echo "  --help                 Same as 'help'"
    echo ""
    echo "If no action is specified, defaults to 'drun' mode."
    exit 0
    ;;
  *)
    exec "$0" drun
    ;;
  esac
''
