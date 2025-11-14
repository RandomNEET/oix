{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
pkgs.writeShellScriptBin "hypr-keybinds" ''
  set -euo pipefail

  TERMINAL=${lib.escapeShellArg opts.terminal}
  FILEMANAGER=${lib.escapeShellArg opts.terminalFileManager}
  EDITOR=${lib.escapeShellArg opts.editor}
  BROWSER=${lib.escapeShellArg opts.browser}

  KEYBINDERS=(
    "SUPER Return" "Launch terminal" "$TERMINAL"
    "SUPER T" "Launch terminal" "$TERMINAL"
    "SUPER F" "Launch file manager" "$FILEMANAGER"
    "SUPER E" "Launch editor" "$EDITOR"
    "SUPER B" "Launch browser" "$BROWSER"
    "CTRL ALT Delete" "Open system monitor" "btop"
    "SUPER A" "Launch application menu" "scripts/launcher drun"
    "SUPER SPACE" "Launch application menu" "scripts/launcher drun"
    "SUPER SHIFT W" "Launch wallpaper menu" "scripts/launcher wallpaper"
    "SUPER CTRL W" "Random wallpaper" "scripts/random-wall"
    ${
      if (config.home-manager.users.${opts.users.primary.name}.programs.tmux.enable or false) then
        ''"SUPER SHIFT T" "Launch tmux sessions" "scripts/launcher tmux"''
      else
        ""
    }
    ${
      if (opts.rbw.rofi-rbw or false) then
        ''"SUPER ALT U" "Launch password manager" "scripts/launcher rbw"''
      else
        ""
    }
    ${
      if (config.programs.steam.enable or false) then
        ''"SUPER G" "Game launcher" "scripts/launcher games" "SUPER ALT G" "Enable game mode" "scripts/gamemode.sh"''
      else
        ""
    }
    "SUPER F9" "Enable night mode" "hyprsunset --temperature 2500"
    "SUPER F10" "Disable night mode" "pkill hyprsunset"
    "SUPER F8" "Toggle autoclicker" "scripts/autoclicker.nix"
    "SUPER CTRL C" "Colour picker" "hyprpicker --autocopy"
    "SUPER, Left Click" "Move window with mouse" "movewindow"
    "SUPER, Right Click" "Resize window with mouse" "resizewindow"
    "SUPER SHIFT →" "Resize window right" "resizeactive 30 0"
    "SUPER SHIFT ←" "Resize window left" "resizeactive -30 0"
    "SUPER SHIFT ↑" "Resize window up" "resizeactive 0 -30"
    "SUPER SHIFT ↓" "Resize window down" "resizeactive 0 30"
    "SUPER SHIFT L" "Resize window right (HJKL)" "resizeactive 30 0"
    "SUPER SHIFT H" "Resize window left (HJKL)" "resizeactive -30 0"
    "SUPER SHIFT K" "Resize window up (HJKL)" "resizeactive 0 -30"
    "SUPER SHIFT J" "Resize window down (HJKL)" "resizeactive 0 30"
    "XF86MonBrightnessDown" "Decrease brightness" "brightnessctl set 2%-"
    "XF86MonBrightnessUp" "Increase brightness" "brightnessctl set +2%"
    "XF86AudioLowerVolume" "Lower volume" "pamixer -d 2"
    "XF86AudioRaiseVolume" "Increase volume" "pamixer -i 2%"
    "XF86AudioMicMute" "Mute microphone" "pamixer --default-source -t"
    "XF86AudioMute" "Mute audio" "pamixer -t"
    "XF86AudioPlay" "Play/Pause media" "playerctl play-pause"
    "XF86AudioNext" "Next media track" "playerctl next"
    "XF86AudioPrev" "Previous media track" "playerctl previous"
    "SUPER Delete" "Exit Hyprland session" "exit"
    "SUPER W" "Toggle floating window" "togglefloating"
    "SUPER SHIFT G" "Toggle window group" "togglegroup"
    "ALT Return" "Toggle fullscreen" "fullscreen"
    "SUPER ALT L" "Lock screen" "hyprlock"
    "SUPER Backspace" "Power menu" "wlogout -b 4"
    "CTRL Escape" "Toggle Waybar" "pkill waybar || waybar"
    "SUPER SHIFT N" "Open notification panel" "swaync-client -t -sw"
    "SUPER SHIFT Q" "Open notification panel" "swaync-client -t -sw"
    "SUPER Q" "Close active window" "killactive"
    "ALT F4" "Close active window" "killactive"
    "SUPER V" "Clipboard manager" "scripts/clip-manager.sh"
    "SUPER ALT K" "Change keyboard layout" "scripts/keyboard-switch.sh"
    "SUPER P" "Screenshot (select area)" "scripts/screenshot.sh s"
    "SUPER CTRL P" "Screenshot (frozen screen)" "scripts/screenshot.sh sf"
    "SUPER Print" "Screenshot (current monitor)" "scripts/screenshot.sh m"
    "SUPER ALT P" "Screenshot (all monitors)" "scripts/screenshot.sh p"
    "SUPER SHIFT CTRL ←" "Move window left" "movewindow l"
    "SUPER SHIFT CTRL →" "Move window right" "movewindow r"
    "SUPER SHIFT CTRL ↑" "Move window up" "movewindow u"
    "SUPER SHIFT CTRL ↓" "Move window down" "movewindow d"
    "SUPER CTRL S" "Move to scratchpad" "movetoworkspacesilent special"
    "SUPER S" "Toggle scratchpad workspace" "togglespecialworkspace"
    "SUPER Tab" "Cycle next window" "cyclenext"
    "SUPER Tab" "Bring active window to top" "bringactivetotop"
    "SUPER CTRL →" "Switch to next workspace" "workspace r+1"
    "SUPER CTRL ←" "Switch to previous workspace" "workspace r-1"
    "SUPER CTRL ↓" "Go to first empty workspace" "workspace empty"
    "SUPER ←" "Move focus left" "movefocus l"
    "SUPER →" "Move focus right" "movefocus r"
    "SUPER ↑" "Move focus up" "movefocus u"
    "SUPER ↓" "Move focus down" "movefocus d"
    "ALT Tab" "Move focus down" "movefocus d"
    "SUPER 1-0" "Switch to workspace 1-10" "workspace 1-10"
    "SUPER SHIFT 1-0" "Move to workspace 1-10" "movetoworkspace 1-10"
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
