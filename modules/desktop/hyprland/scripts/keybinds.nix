{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
pkgs.writeShellScriptBin "keybinds" ''
  set -euo pipefail

  TERMINAL=${lib.escapeShellArg opts.terminal}
  FILEMANAGER=${lib.escapeShellArg opts.terminalFileManager}
  EDITOR=${lib.escapeShellArg opts.editor}
  BROWSER=${lib.escapeShellArg opts.browser}

  KEYBINDERS=(
    "SUPER SHIFT /" "Show keybinds" "scripts/keybinds"
    "SUPER Return" "Launch terminal" "$TERMINAL"
    "SUPER T" "Launch terminal" "$TERMINAL"
    "SUPER F" "Launch file manager" "$FILEMANAGER"
    "SUPER E" "Launch editor" "$EDITOR"
    "SUPER B" "Launch browser" "$BROWSER"
    "SUPER A" "Launch application menu" "scripts/launcher drun"
    "SUPER SPACE" "Launch application menu" "scripts/launcher drun"
    "SUPER SHIFT W" "Select wallpaper" "scripts/launcher wallpaper"
    "SUPER CTRL W" "Random wallpaper" "scripts/random-wall"
    "SUPER CTRL T" "Select theme" "scripts/launcher theme"
    "SUPER ALT S" "Select specialisation" "scripts/launcher spec"
    ${lib.optionalString config.home-manager.users.${opts.users.primary.name}.programs.tmux.enable
      ''"SUPER SHIFT T" "Launch tmux sessions" "scripts/launcher tmux"''
    }
    ${lib.optionalString (opts.rbw.rofi-rbw or false
    ) ''"SUPER ALT U" "Launch password manager" "scripts/launcher rbw"''}
    ${lib.optionalString config.programs.steam.enable ''"SUPER SHIFT G" "Game launcher" "scripts/launcher game"''}
    "SUPER V" "Clipboard manager" "scripts/clip-manager"
    "SUPER SHIFT N" "Open notification panel" "swaync-client -t -sw"
    "SUPER SHIFT Q" "Open notification panel" "swaync-client -t -sw"
    "CTRL ALT Delete" "Open system monitor" "btop"
    "SUPER CTRL C" "Colour picker" "hyprpicker --autocopy"
    ${lib.optionalString config.programs.steam.enable ''"SUPER CTRL G" "Enable game mode" "scripts/gamemode.sh"''}
    "SUPER F8" "Toggle autoclicker" "scripts/autoclicker"
    "SUPER F9" "Enable night mode" "hyprsunset --temperature 2500"
    "SUPER F10" "Disable night mode" "pkill hyprsunset"
    "SUPER P" "Screenshot (select area)" "scripts/screenshot.sh s"
    "SUPER CTRL P" "Screenshot (frozen screen)" "scripts/screenshot.sh sf"
    "SUPER ALT P" "Screenshot (all monitors)" "scripts/screenshot.sh p"
    "SUPER Print" "Screenshot (current monitor)" "scripts/screenshot.sh m"
    "SUPER SHIFT Print" "OCR capture (select area)" "scripts/screenshot.sh o"
    # "SUPER Tab" "Toggle overview" "overview:toggle"
    "SUPER W" "Toggle floating window" "togglefloating"
    "SUPER G" "Toggle group window" "togglegroup"
    "ALT Return" "Toggle fullscreen" "fullscreen"
    "SUPER Q" "Close active window" "killactive"
    "SUPER ALT L" "Lock screen" "hyprlock"
    "SUPER Backspace" "Power menu" "wlogout -b 4"
    "CTRL Escape" "Toggle Waybar" "toggle waybar service"
    "SUPER S" "Toggle scratchpad workspace" "togglespecialworkspace"
    "SUPER CTRL S" "Move to scratchpad" "movetoworkspacesilent special"
    "SUPER H" "Move focus left (HJKL)" "movefocus l"
    "SUPER L" "Move focus right (HJKL)" "movefocus r"
    "SUPER J" "Move focus up (HJKL)" "movefocus u"
    "SUPER K" "Move focus down (HJKL)" "movefocus d"
    "SUPER ←" "Move focus left" "movefocus l"
    "SUPER →" "Move focus right" "movefocus r"
    "SUPER ↑" "Move focus up" "movefocus u"
    "SUPER ↓" "Move focus down" "movefocus d"
    "SUPER ALT K" "Move group focus back" "changegroupactive back"
    "SUPER ALT J" "Move group focus forward" "changegroupactive forward"
    "SUPER 1-0" "Switch to workspace 1-10" "workspace 1-10"
    "SUPER SHIFT 1-0" "Move to workspace 1-10" "movetoworkspace 1-10"
    "ALT Tab" "Cycle next window" "cyclenext"
    "ALT Tab" "Bring active window to top" "bringactivetotop"
    "SUPER SHIFT CTRL H" "Move window left (HJKL)" "movewindow l"
    "SUPER SHIFT CTRL L" "Move window right (HJKL)" "movewindow r"
    "SUPER SHIFT CTRL K" "Move window up (HJKL)" "movewindow u"
    "SUPER SHIFT CTRL J" "Move window down (HJKL)" "movewindow d"
    "SUPER SHIFT CTRL ←" "Move window left" "movewindow l"
    "SUPER SHIFT CTRL →" "Move window right" "movewindow r"
    "SUPER SHIFT CTRL ↑" "Move window up" "movewindow u"
    "SUPER SHIFT CTRL ↓" "Move window down" "movewindow d"
    "SUPER CTRL →" "Switch to next workspace" "workspace r+1"
    "SUPER CTRL ←" "Switch to previous workspace" "workspace r-1"
    "SUPER CTRL ↓" "Go to first empty workspace" "workspace empty"
    "SUPER, Left Click" "Move window with mouse" "movewindow"
    "SUPER, Right Click" "Resize window with mouse" "resizewindow"
    "SUPER SHIFT H" "Resize window left (HJKL)" "resizeactive -30 0"
    "SUPER SHIFT L" "Resize window right (HJKL)" "resizeactive 30 0"
    "SUPER SHIFT K" "Resize window up (HJKL)" "resizeactive 0 -30"
    "SUPER SHIFT J" "Resize window down (HJKL)" "resizeactive 0 30"
    "SUPER SHIFT ←" "Resize window left" "resizeactive -30 0"
    "SUPER SHIFT →" "Resize window right" "resizeactive 30 0"
    "SUPER SHIFT ↑" "Resize window up" "resizeactive 0 -30"
    "SUPER SHIFT ↓" "Resize window down" "resizeactive 0 30"
    "XF86MonBrightnessDown" "Decrease brightness" "brightnessctl set 2%-"
    "XF86MonBrightnessUp" "Increase brightness" "brightnessctl set +2%"
    "XF86AudioLowerVolume" "Lower volume" "pamixer -d 2"
    "XF86AudioRaiseVolume" "Increase volume" "pamixer -i 2%"
    "XF86AudioMicMute" "Mute microphone" "pamixer --default-source -t"
    "XF86AudioMute" "Mute audio" "pamixer -t"
    "XF86AudioPlay" "Play/Pause media" "playerctl play-pause"
    "XF86AudioNext" "Next media track" "playerctl next"
    "XF86AudioPrev" "Previous media track" "playerctl previous"
    "SUPER M" "Enter mouse mode" "submap mouse-mode"
    "(mouse-mode) H" "Mouse move left" "exec wlrctl pointer move -10 0"
    "(mouse-mode) L" "Mouse move right" "exec wlrctl pointer move 10 0"
    "(mouse-mode) K" "Mouse move up" "exec wlrctl pointer move 0 -10"
    "(mouse-mode) J" "Mouse move down" "exec wlrctl pointer move 0 10"
    "(mouse-mode) SHIFT H" "Mouse move left (fast)" "exec wlrctl pointer move -100 0"
    "(mouse-mode) SHIFT L" "Mouse move right (fast)" "exec wlrctl pointer move 100 0"
    "(mouse-mode) SHIFT K" "Mouse move up (fast)" "exec wlrctl pointer move 0 -100"
    "(mouse-mode) SHIFT J" "Mouse move down (fast)" "exec wlrctl pointer move 0 100"
    "(mouse-mode) ," "Mouse left click" "exec wlrctl pointer click left"
    "(mouse-mode) ." "Mouse right click" "exec wlrctl pointer click right"
    "(mouse-mode) Escape" "Exit mouse mode" "submap reset"
    "(mouse-mode) Q" "Exit mouse mode" "submap reset"
     )

  yad --center \
    --title="Hyprland Keybinds" \
    --no-buttons \
    --list \
    --width=745 \
    --height=920 \
    --column=Key: --column=Description: --column=Command: \
    --timeout-indicator=bottom \
    "''${KEYBINDERS[@]}"
''
