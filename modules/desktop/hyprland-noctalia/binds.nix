{
  osConfig,
  config,
  lib,
  pkgs,
  opts,
  launcher,
  clip-manager,
  autoclicker,
  keybinds,
  screenshot,
  gamemode,
  getExe,
  ...
}:
{
  "$mainMod" = "SUPER";
  "$terminal" =
    if ((opts.terminal == "foot") && (opts.foot.server or false)) then
      "footclient"
    else
      "${opts.terminal}";
  "$fileManager" =
    if (opts.terminal == "kitty") then
      ''$terminal --class "terminalFileManager" -e ${opts.terminalFileManager}''
    else if (opts.terminal == "foot") then
      ''$terminal --app-id "terminalFileManager" -e ${opts.terminalFileManager}''
    else
      "$terminal -e ${opts.terminalFileManager}";
  "$editor" =
    if (opts.terminal == "kitty") then
      ''$terminal --class "editor" -e ${opts.editor}''
    else if (opts.terminal == "foot") then
      ''$terminal --app-id "editor" -e ${opts.editor}''
    else
      "$terminal -e ${opts.editor}";
  "$browser" = opts.browser;

  bind = [
    # Keybinds help menu
    "$mainMod SHIFT, slash, exec, ${keybinds}"

    # Window/Session actions
    # "$mainMod, Tab, overview:toggle" # toggle overview
    "$mainMod, W, togglefloating" # toggle the window on focus to float
    "$mainMod, G, togglegroup" # toggle the window on focus to group
    "ALT, return, fullscreen" # toggle the window on focus to fullscreen
    "$mainMod, Q, killactive" # killactive, kill the window on focus
    "$mainMod ALT, L, exec, noctalia-shell ipc call lockScreen lock" # lock screen
    "$mainMod, backspace, exec, noctalia-shell ipc call sessionMenu toggle" # session menu
    "$CONTROL, ESCAPE, exec, noctalia-shell ipc call bar toggle" # toggle bar

    # Special workspace (scratchpad)
    "$mainMod, S, togglespecialworkspace"
    "$mainMod CTRL, S, movetoworkspacesilent, special"

    # Applications/Programs
    "$mainMod, Return, exec, $terminal"
    "$mainMod, T, exec, [float;center;size 1000 600] $terminal"
    "$mainMod, F, exec, $fileManager"
    "$mainMod, E, exec, $editor"
    "$mainMod, B, exec, $browser"

    "$mainMod, SPACE, exec, ${launcher} drun" # launch desktop applications
    "$mainMod, V, exec, ${clip-manager}" # Clipboard Manager
    "$mainMod CTRL, T, exec, ${launcher} theme" # launch theme switcher
    "$mainMod ALT, S, exec, ${launcher} spec" # launch specialisation  switcher
  ]
  ++ lib.optional config.programs.tmux.enable "$mainMod SHIFT, T, exec, ${launcher} tmux" # launch tmux sessions
  ++ lib.optional (opts.rbw.rofi-rbw or false) "$mainMod ALT, U, exec, ${launcher} rbw" # launch password manager
  ++ lib.optionals osConfig.programs.steam.enable [
    "$mainMod SHIFT, G, exec, ${launcher} game" # game launcher
    "$mainMod CTRL, G, exec, ${gamemode}" # disable hypr effects for gamemode
  ]
  ++ [
    "$mainMod SHIFT, A, exec, noctalia-shell ipc call controlCenter toggle" # control center
    "$mainMod SHIFT, Q, exec, noctalia-shell ipc call notifications toggleHistory" # notification history
    "$mainMod CTRL, W, exec, noctalia-shell ipc call wallpaper toggle" # launch wallpaper selector
    "$mainMod SHIFT, W, exec, noctalia-shell ipc call wallpaper random" # random wallpaper

    "$mainMod, F10, exec, $terminal -e ${getExe pkgs.btop}" # System Monitor
    "$mainMod, F11, exec, pkill hyprpicker || hyprpicker --autocopy --format=hex" # Colour Picker
    "$mainMod, F12, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40"

    # Screenshot/Screencapture
    "$mainMod, P, exec, ${screenshot} s" # drag to snip an area / click on a window to print it
    "$mainMod SHIFT, P, exec, ${screenshot} sf" # frozen screen, drag to snip an area / click on a window to print it
    "$mainMod CTRL, P, exec, ${screenshot} m" # print focused monitor
    "$mainMod ALT, P, exec, ${screenshot} p" # print all monitor outputs
    "$mainMod, print, exec, ${screenshot} o" # ocr capture

    # Functional keybinds
    ",XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput" # mute output
    ",XF86AudioMicMute, exec, noctalia-shell ipc call volume muteInput" # mute input
    ",XF86AudioPlay, exec, noctalia-shell ipc call media play" # play media
    ",XF86AudioPause, exec, playerctl noctalia-shell ipc call media pause" # pause media
    ",xf86AudioNext, exec, noctalia-shell ipc call media next" # go to next media
    ",xf86AudioPrev, exec, noctalia-shell ipc call media previous" # go to previous media

    # to switch between windows in a floating workspace
    "ALT, Tab, cyclenext"
    "ALT, Tab, bringactivetotop"

    # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
    "$mainMod CTRL, right, workspace, r+1"
    "$mainMod CTRL, left, workspace, r-1"

    # move to the first empty workspace instantly with mainMod + CTRL + [↓]
    "$mainMod CTRL, down, workspace, empty"

    # Move focus with mainMod + arrow keys
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"

    # Move focus with mainMod + HJKL keys
    "$mainMod, h, movefocus, l"
    "$mainMod, l, movefocus, r"
    "$mainMod, k, movefocus, u"
    "$mainMod, j, movefocus, d"
    "$mainMod ALT, k, changegroupactive, b"
    "$mainMod ALT, j, changegroupactive, f"

    # Go to workspace 6 and 7 with mouse side buttons
    "$mainMod, mouse:276, workspace, 1"
    "$mainMod, mouse:275, workspace, 10"
    "$mainMod SHIFT, mouse:276, movetoworkspace, 1"
    "$mainMod SHIFT, mouse:275, movetoworkspace, 10"
    "$mainMod CTRL, mouse:276, movetoworkspacesilent, 1"
    "$mainMod CTRL, mouse:275, movetoworkspacesilent, 10"

    # Scroll through existing workspaces with mainMod + scroll
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
    "$mainMod CTRL ALT, right, movetoworkspace, r+1"
    "$mainMod CTRL ALT, left, movetoworkspace, r-1"

    # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
    "$mainMod SHIFT $CONTROL, left, movewindow, l"
    "$mainMod SHIFT $CONTROL, right, movewindow, r"
    "$mainMod SHIFT $CONTROL, up, movewindow, u"
    "$mainMod SHIFT $CONTROL, down, movewindow, d"

    # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
    "$mainMod SHIFT $CONTROL, H, movewindow, l"
    "$mainMod SHIFT $CONTROL, L, movewindow, r"
    "$mainMod SHIFT $CONTROL, K, movewindow, u"
    "$mainMod SHIFT $CONTROL, J, movewindow, d"

    # Enter mouse mode
    "SUPER, M, submap, mouse-mode"
  ]
  ++ (builtins.concatLists (
    builtins.genList (
      x:
      let
        ws =
          let
            c = (x + 1) / 10;
          in
          builtins.toString (x + 1 - (c * 10));
      in
      [
        "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
        "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        "$mainMod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
      ]
    ) 10
  ))
  ++ (opts.hyprland.settings.bind or [ ]);

  binde = [
    # Resize windows
    "$mainMod SHIFT, right, resizeactive, 30 0"
    "$mainMod SHIFT, left, resizeactive, -30 0"
    "$mainMod SHIFT, up, resizeactive, 0 -30"
    "$mainMod SHIFT, down, resizeactive, 0 30"

    # Resize windows with hjkl keys
    "$mainMod SHIFT, l, resizeactive, 30 0"
    "$mainMod SHIFT, h, resizeactive, -30 0"
    "$mainMod SHIFT, k, resizeactive, 0 -30"
    "$mainMod SHIFT, j, resizeactive, 0 30"

    # Functional keybinds
    ",XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
    ",XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
    ",XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
    ",XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
  ]
  ++ (opts.hyprland.settings.binde or [ ]);

  bindm = [
    # Move/Resize windows with mainMod + LMB/RMB and dragging
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ]
  ++ (opts.hyprland.settings.bindm or [ ]);

  submaps = {
    mouse-mode = {
      settings = {
        binde = [
          # Move around
          ", H, exec, wlrctl pointer move -10 0"
          ", L, exec, wlrctl pointer move 10 0"
          ", K, exec, wlrctl pointer move 0 -10"
          ", J, exec, wlrctl pointer move 0 10"
          "SHIFT, H, exec, wlrctl pointer move -100 0"
          "SHIFT, L, exec, wlrctl pointer move 100 0"
          "SHIFT, K, exec, wlrctl pointer move 0 -100"
          "SHIFT, J, exec, wlrctl pointer move 0 100"
        ];
        bind = [
          # Click
          ", comma, exec, wlrctl pointer click left"
          ", period, exec, wlrctl pointer click right"

          # Exit
          ", escape, submap, reset"
          ", Q, submap, reset"
        ];
      };
    };
  }
  // (opts.hyprland.settings.submaps or { });
}
