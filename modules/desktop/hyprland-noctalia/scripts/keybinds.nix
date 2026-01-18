{
  osConfig,
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  keybinds = [
    # ----- Base -----
    {
      key = "SUPER SHIFT /";
      desc = "Show keybinds";
      cmd = "scripts/keybinds";
    }
    {
      key = "SUPER Return";
      desc = "Launch terminal";
      cmd = opts.terminal;
    }
    {
      key = "SUPER T";
      desc = "Launch terminal (float)";
      cmd = opts.terminal;
    }
    {
      key = "SUPER F";
      desc = "Launch file manager";
      cmd = opts.terminalFileManager;
    }
    {
      key = "SUPER E";
      desc = "Launch editor";
      cmd = opts.editor;
    }
    {
      key = "SUPER B";
      desc = "Launch browser";
      cmd = opts.browser;
    }
    # ----- Launch -----
    {
      key = "SUPER SPACE";
      desc = "Launch application menu";
      cmd = "scripts/launcher drun";
    }
    {
      key = "SUPER V";
      desc = "Clipboard manager";
      cmd = "scripts/clip-manager";
    }
    {
      key = "SUPER CTRL T";
      desc = "Select theme";
      cmd = "scripts/launcher theme";
    }
    {
      key = "SUPER ALT S";
      desc = "Select specialisation";
      cmd = "scripts/launcher spec";
    }
  ]
  ++ lib.optionals (config.programs.tmux.enable or false) [
    {
      key = "SUPER SHIFT T";
      desc = "Launch tmux sessions";
      cmd = "scripts/launcher tmux";
    }
  ]
  ++ lib.optionals (opts.rbw.rofi-rbw or false) [
    {
      key = "SUPER ALT U";
      desc = "Launch password manager";
      cmd = "scripts/launcher rbw";
    }
  ]
  ++ lib.optionals (osConfig.programs.steam.enable or false) [
    {
      key = "SUPER SHIFT G";
      desc = "Game launcher";
      cmd = "scripts/launcher game";
    }
    {
      key = "SUPER CTRL G";
      desc = "Enable game mode";
      cmd = "scripts/gamemode.sh";
    }
  ]
  ++ [
    # ----- Util -----
    {
      key = "SUPER SHIFT Q";
      desc = "Open control center";
      cmd = "noctalia controlCenter toggle";
    }
    {
      key = "SUPER SHIFT N";
      desc = "Open notification history";
      cmd = "noctalia notifications toggleHistory";
    }
    {
      key = "SUPER CTRL W";
      desc = "Select wallpaper";
      cmd = "noctalia wallpaper toggle";
    }
    {
      key = "SUPER SHIFT W";
      desc = "Random wallpaper";
      cmd = "noctalia wallpaper random";
    }
    {
      key = "SUPER ALT L";
      desc = "Lock screen";
      cmd = "noctalia lockScreen lock";
    }
    {
      key = "SUPER Backspace";
      desc = "Session menu";
      cmd = "noctalia sessionMenu toggle";
    }
    {
      key = "CTRL Escape";
      desc = "Toggle bar";
      cmd = "noctalia bar toggle";
    }
    # ----- F keys -----
    {
      key = "SUPER F10";
      desc = "Open system monitor";
      cmd = "btop";
    }
    {
      key = "SUPER F11";
      desc = "Colour picker";
      cmd = "hyprpicker --autocopy";
    }
    {
      key = "SUPER F12";
      desc = "Toggle autoclicker";
      cmd = "scripts/autoclicker";
    }
    # ----- Screenshot -----
    {
      key = "SUPER P";
      desc = "Screenshot (select area)";
      cmd = "scripts/screenshot.sh s";
    }
    {
      key = "SUPER SHIFT P";
      desc = "Screenshot (frozen screen)";
      cmd = "scripts/screenshot.sh sf";
    }
    {
      key = "SUPER CTRL P";
      desc = "Screenshot (current monitor)";
      cmd = "scripts/screenshot.sh m";
    }
    {
      key = "SUPER ALT P";
      desc = "Screenshot (all monitors)";
      cmd = "scripts/screenshot.sh p";
    }
    {
      key = "SUPER Print";
      desc = "OCR capture (select area)";
      cmd = "scripts/screenshot.sh o";
    }
    # ----- Window control -----
    {
      key = "SUPER W";
      desc = "Toggle floating window";
      cmd = "togglefloating";
    }
    {
      key = "SUPER G";
      desc = "Toggle group window";
      cmd = "togglegroup";
    }
    {
      key = "ALT Return";
      desc = "Toggle fullscreen";
      cmd = "fullscreen";
    }
    {
      key = "SUPER Q";
      desc = "Close active window";
      cmd = "killactive";
    }
    {
      key = "SUPER S";
      desc = "Toggle scratchpad workspace";
      cmd = "togglespecialworkspace";
    }
    {
      key = "SUPER CTRL S";
      desc = "Move to scratchpad";
      cmd = "movetoworkspacesilent special";
    }
    # {
    #   key = "SUPER Tab";
    #   desc = "Toggle overview";
    #   cmd = "overview:toggle";
    # }
    # ----- Focus & Workspace -----
    {
      key = "SUPER H";
      desc = "Move focus left (HJKL)";
      cmd = "movefocus l";
    }
    {
      key = "SUPER L";
      desc = "Move focus right (HJKL)";
      cmd = "movefocus r";
    }
    {
      key = "SUPER J";
      desc = "Move focus up (HJKL)";
      cmd = "movefocus u";
    }
    {
      key = "SUPER K";
      desc = "Move focus down (HJKL)";
      cmd = "movefocus d";
    }
    {
      key = "SUPER ←";
      desc = "Move focus left";
      cmd = "movefocus l";
    }
    {
      key = "SUPER →";
      desc = "Move focus right";
      cmd = "movefocus r";
    }
    {
      key = "SUPER ↑";
      desc = "Move focus up";
      cmd = "movefocus u";
    }
    {
      key = "SUPER ↓";
      desc = "Move focus down";
      cmd = "movefocus d";
    }
    {
      key = "SUPER ALT K";
      desc = "Move group focus back";
      cmd = "changegroupactive back";
    }
    {
      key = "SUPER ALT J";
      desc = "Move group focus forward";
      cmd = "changegroupactive forward";
    }
    {
      key = "SUPER 1-0";
      desc = "Switch to workspace 1-10";
      cmd = "workspace 1-10";
    }
    {
      key = "SUPER SHIFT 1-0";
      desc = "Move to workspace 1-10";
      cmd = "movetoworkspace 1-10";
    }
    {
      key = "ALT Tab";
      desc = "Cycle next window";
      cmd = "cyclenext";
    }
    {
      key = "ALT Tab";
      desc = "Bring active window to top";
      cmd = "bringactivetotop";
    }

    {
      key = "SUPER SHIFT CTRL H";
      desc = "Move window left (HJKL)";
      cmd = "movewindow l";
    }
    {
      key = "SUPER SHIFT CTRL L";
      desc = "Move window right (HJKL)";
      cmd = "movewindow r";
    }
    {
      key = "SUPER SHIFT CTRL K";
      desc = "Move window up (HJKL)";
      cmd = "movewindow u";
    }
    {
      key = "SUPER SHIFT CTRL J";
      desc = "Move window down (HJKL)";
      cmd = "movewindow d";
    }
    {
      key = "SUPER SHIFT CTRL ←";
      desc = "Move window left";
      cmd = "movewindow l";
    }
    {
      key = "SUPER SHIFT CTRL →";
      desc = "Move window right";
      cmd = "movewindow r";
    }
    {
      key = "SUPER SHIFT CTRL ↑";
      desc = "Move window up";
      cmd = "movewindow u";
    }
    {
      key = "SUPER SHIFT CTRL ↓";
      desc = "Move window down";
      cmd = "movewindow d";
    }

    {
      key = "SUPER CTRL →";
      desc = "Switch to next workspace";
      cmd = "workspace r+1";
    }
    {
      key = "SUPER CTRL ←";
      desc = "Switch to previous workspace";
      cmd = "workspace r-1";
    }
    {
      key = "SUPER CTRL ↓";
      desc = "Go to first empty workspace";
      cmd = "workspace empty";
    }

    {
      key = "SUPER, Left Click";
      desc = "Move window with mouse";
      cmd = "movewindow";
    }
    {
      key = "SUPER, Right Click";
      desc = "Resize window with mouse";
      cmd = "resizewindow";
    }

    {
      key = "SUPER SHIFT H";
      desc = "Resize window left (HJKL)";
      cmd = "resizeactive -30 0";
    }
    {
      key = "SUPER SHIFT L";
      desc = "Resize window right (HJKL)";
      cmd = "resizeactive 30 0";
    }
    {
      key = "SUPER SHIFT K";
      desc = "Resize window up (HJKL)";
      cmd = "resizeactive 0 -30";
    }
    {
      key = "SUPER SHIFT J";
      desc = "Resize window down (HJKL)";
      cmd = "resizeactive 0 30";
    }
    {
      key = "SUPER SHIFT ←";
      desc = "Resize window left";
      cmd = "resizeactive -30 0";
    }
    {
      key = "SUPER SHIFT →";
      desc = "Resize window right";
      cmd = "resizeactive 30 0";
    }
    {
      key = "SUPER SHIFT ↑";
      desc = "Resize window up";
      cmd = "resizeactive 0 -30";
    }
    {
      key = "SUPER SHIFT ↓";
      desc = "Resize window down";
      cmd = "resizeactive 0 30";
    }
    # ----- XF86 -----
    {
      key = "XF86AudioPlay";
      desc = "Play media";
      cmd = "noctalia media play";
    }
    {
      key = "XF86AudioPlay";
      desc = "Pause media";
      cmd = "noctalia media pause";
    }
    {
      key = "XF86AudioNext";
      desc = "Next media track";
      cmd = "noctalia media next";
    }
    {
      key = "XF86AudioPrev";
      desc = "Previous media track";
      cmd = "noctalia media previous";
    }
    {
      key = "XF86AudioMute";
      desc = "Mute output";
      cmd = "noctalia volume muteOutput";
    }
    {
      key = "XF86AudioMicMute";
      desc = "Mute input";
      cmd = "noctalia volume muteIutput";
    }
    {
      key = "XF86MonBrightnessDown";
      desc = "Decrease brightness";
      cmd = "noctalia brightness decrease";
    }
    {
      key = "XF86MonBrightnessUp";
      desc = "Increase brightness";
      cmd = "noctalia brightness increase";
    }
    {
      key = "XF86AudioLowerVolume";
      desc = "Lower volume";
      cmd = "noctalia volume decrease";
    }
    {
      key = "XF86AudioRaiseVolume";
      desc = "Increase volume";
      cmd = "noctalia volume increase";
    }
    # ----- Submap -----
    {
      key = "SUPER M";
      desc = "Enter mouse mode";
      cmd = "submap mouse-mode";
    }
    {
      key = "(mouse-mode) H";
      desc = "Mouse move left";
      cmd = "wlrctl pointer move -10 0";
    }
    {
      key = "(mouse-mode) L";
      desc = "Mouse move right";
      cmd = "wlrctl pointer move 10 0";
    }
    {
      key = "(mouse-mode) K";
      desc = "Mouse move up";
      cmd = "wlrctl pointer move 0 -10";
    }
    {
      key = "(mouse-mode) J";
      desc = "Mouse move down";
      cmd = "wlrctl pointer move 0 10";
    }
    {
      key = "(mouse-mode) SHIFT H";
      desc = "Mouse move left (fast)";
      cmd = "wlrctl pointer move -100 0";
    }
    {
      key = "(mouse-mode) SHIFT L";
      desc = "Mouse move right (fast)";
      cmd = "wlrctl pointer move 100 0";
    }
    {
      key = "(mouse-mode) SHIFT K";
      desc = "Mouse move up (fast)";
      cmd = "wlrctl pointer move 0 -100";
    }
    {
      key = "(mouse-mode) SHIFT J";
      desc = "Mouse move down (fast)";
      cmd = "wlrctl pointer move 0 100";
    }
    {
      key = "(mouse-mode) ,";
      desc = "Mouse left click";
      cmd = "wlrctl pointer click left";
    }
    {
      key = "(mouse-mode) .";
      desc = "Mouse right click";
      cmd = "wlrctl pointer click right";
    }
    {
      key = "(mouse-mode) Escape";
      desc = "Exit mouse mode";
      cmd = "submap reset";
    }
    {
      key = "(mouse-mode) Q";
      desc = "Exit mouse mode";
      cmd = "submap reset";
    }
  ]
  ++ (opts.hyprland.showKeybinds or [ ]);
  flattenedBinds = lib.concatLists (
    map (item: [
      item.key
      item.desc
      item.cmd
    ]) keybinds
  );
  shellArrayContent = lib.concatStringsSep "\n    " (map lib.escapeShellArg flattenedBinds);
in
pkgs.writeShellScriptBin "keybinds" ''
  set -euo pipefail
  KEYBINDERS=(${shellArrayContent})
  yad --center \
    --title="Hyprland Keybinds" \
    --no-buttons \
    --list \
    --column=Key: --column=Description: --column=Command: \
    --timeout-indicator=bottom \
    "''${KEYBINDERS[@]}"
''
