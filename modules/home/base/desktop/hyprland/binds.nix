{
  osConfig,
  config,
  lib,
  pkgs,
  launcher,
  clip-manager,
  file-manager,
  screenshot,
  autoclicker,
  keybinds,
  gamespace,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  mkBind = keys: action: {
    _args = [
      keys
      (mkLuaInline action)
    ];
  };
  mkBindRepeat = keys: action: {
    _args = [
      keys
      (mkLuaInline action)
      { repeating = true; }
    ];
  };
  mkBindLocked = keys: action: {
    _args = [
      keys
      (mkLuaInline action)
      { locked = true; }
    ];
  };
  mkBindLockedRepeat = keys: action: {
    _args = [
      keys
      (mkLuaInline action)
      {
        locked = true;
        repeating = true;
      }
    ];
  };
  mkBindMouse = keys: action: {
    _args = [
      keys
      (mkLuaInline action)
      { mouse = true; }
    ];
  };

  termInfo = import ../shared/misc/terminal.nix { inherit config; };
  terminal = termInfo.exe;
  fileManager = "${file-manager} ${config.defaultPrograms.fileManager}";
  editor = "${terminal} ${termInfo.classFlag} editor -e ${config.defaultPrograms.editor}";
  browser = config.defaultPrograms.browser;
in
{
  bind = [
    # Keybinds help menu
    (mkBind "SUPER + SHIFT + slash" ''hl.dsp.exec_cmd("${keybinds}")'')

    # Window/Session actions
    (mkBind "SUPER + Q" "hl.dsp.window.close()")
    (mkBind "SUPER + W" ''hl.dsp.window.float({ action = "toggle" })'')
    (mkBind "SUPER + G" "hl.dsp.group.toggle()")
    (mkBind "ALT + return" ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
    (mkBind "SUPER + ALT + L" ''hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock")'')
    (mkBind "SUPER + backspace" ''hl.dsp.exec_cmd("noctalia-shell ipc call sessionMenu toggle")'')
    (mkBind "CTRL + ESCAPE" ''hl.dsp.exec_cmd("noctalia-shell ipc call bar toggle")'')

    # Special workspace (scratchpad)
    (mkBind "SUPER + S" "hl.dsp.workspace.toggle_special()")
    (mkBind "SUPER + CTRL + S" ''hl.dsp.window.move({ workspace = "special", follow = false })'')

    # Applications/Programs
    (mkBind "SUPER + Return" ''hl.dsp.exec_cmd("${terminal}")'')
    (mkBind "SUPER + F" ''hl.dsp.exec_cmd("${fileManager}")'')
    (mkBind "SUPER + E" ''hl.dsp.exec_cmd("${editor}")'')
    (mkBind "SUPER + B" ''hl.dsp.exec_cmd("${browser}")'')
    (mkBind "SUPER + SPACE" ''hl.dsp.exec_cmd("${launcher} drun")'')
    (mkBind "SUPER + V" ''hl.dsp.exec_cmd("${clip-manager}")'')
    (mkBind "SUPER + CTRL + T" ''hl.dsp.exec_cmd("${launcher} theme")'')
    (mkBind "SUPER + ALT + S" ''hl.dsp.exec_cmd("${launcher} spec")'')
    (mkBind "SUPER + SHIFT + A" ''hl.dsp.exec_cmd("noctalia-shell ipc call controlCenter toggle")'')
    (mkBind "SUPER + SHIFT + Q" ''hl.dsp.exec_cmd("noctalia-shell ipc call notifications toggleHistory")'')
    (mkBind "SUPER + CTRL + W" ''hl.dsp.exec_cmd("noctalia-shell ipc call wallpaper toggle")'')
    (mkBind "SUPER + SHIFT + W" ''hl.dsp.exec_cmd("noctalia-shell ipc call wallpaper random all")'')
    (mkBind "SUPER + F10" ''hl.dsp.exec_cmd("${terminal} -e ${lib.getExe pkgs.btop}")'')
    (mkBind "SUPER + F11" ''hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker --autocopy --format=hex")'')
    (mkBind "SUPER + F12" ''hl.dsp.exec_cmd("kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40")'')

    # Screenshot/Screencapture
    (mkBind "SUPER + P" ''hl.dsp.exec_cmd("${screenshot} s")'') # drag to snip an area / click on a window to print it
    (mkBind "SUPER + SHIFT + P" ''hl.dsp.exec_cmd("${screenshot} a")'') # print all monitor outputs
    (mkBind "SUPER + CTRL + P" ''hl.dsp.exec_cmd("${screenshot} o")'') # ocr capture

    # to switch between windows in a floating workspace
    (mkBind "ALT + Tab" "hl.dsp.window.cycle_next({ next = true })")
    (mkBind "ALT + Tab" ''hl.dsp.window.alter_zorder({ mode = "top" })'')

    # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
    (mkBind "SUPER + CTRL + right" ''hl.dsp.focus({ workspace = "r+1" })'')
    (mkBind "SUPER + CTRL + left" ''hl.dsp.focus({ workspace = "r-1" })'')

    # move to the first empty workspace instantly with mainMod + CTRL + [↓]
    (mkBind "SUPER + CTRL + down" ''hl.dsp.focus({ workspace = "empty" })'')

    # Move focus with mainMod + arrow keys
    (mkBind "SUPER + left" ''hl.dsp.focus({ direction = "l" })'')
    (mkBind "SUPER + right" ''hl.dsp.focus({ direction = "r" })'')
    (mkBind "SUPER + up" ''hl.dsp.focus({ direction = "u" })'')
    (mkBind "SUPER + down" ''hl.dsp.focus({ direction = "d" })'')

    # Move focus with mainMod + HJKL keys
    (mkBind "SUPER + h" ''hl.dsp.focus({ direction = "l" })'')
    (mkBind "SUPER + l" ''hl.dsp.focus({ direction = "r" })'')
    (mkBind "SUPER + k" ''hl.dsp.focus({ direction = "u" })'')
    (mkBind "SUPER + j" ''hl.dsp.focus({ direction = "d" })'')
    (mkBind "SUPER + ALT + k" "hl.dsp.group.prev()")
    (mkBind "SUPER + ALT + j" "hl.dsp.group.next()")

    # Go to workspace 6 and 7 with mouse side buttons
    (mkBind "SUPER + mouse:276" "hl.dsp.focus({ workspace = 1 })")
    (mkBind "SUPER + mouse:275" "hl.dsp.focus({ workspace = 10 })")
    (mkBind "SUPER + SHIFT + mouse:276" "hl.dsp.window.move({ workspace = 1 })")
    (mkBind "SUPER + SHIFT + mouse:275" "hl.dsp.window.move({ workspace = 10 })")
    (mkBind "SUPER + CTRL + mouse:276" "hl.dsp.window.move({ workspace = 1, follow = false })")
    (mkBind "SUPER + CTRL + mouse:275" "hl.dsp.window.move({ workspace = 10, follow = false })")

    # Scroll through existing workspaces with mainMod + scroll
    (mkBind "SUPER + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
    (mkBind "SUPER + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

    # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
    (mkBind "SUPER + CTRL + ALT + right" ''hl.dsp.window.move({ workspace = "r+1" })'')
    (mkBind "SUPER + CTRL + ALT + left" ''hl.dsp.window.move({ workspace = "r-1" })'')

    # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
    (mkBind "SUPER + SHIFT + CTRL + left" ''hl.dsp.window.move({ direction = "l" })'')
    (mkBind "SUPER + SHIFT + CTRL + right" ''hl.dsp.window.move({ direction = "r" })'')
    (mkBind "SUPER + SHIFT + CTRL + up" ''hl.dsp.window.move({ direction = "u" })'')
    (mkBind "SUPER + SHIFT + CTRL + down" ''hl.dsp.window.move({ direction = "d" })'')

    # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
    (mkBind "SUPER + SHIFT + CTRL + H" ''hl.dsp.window.move({ direction = "l" })'')
    (mkBind "SUPER + SHIFT + CTRL + L" ''hl.dsp.window.move({ direction = "r" })'')
    (mkBind "SUPER + SHIFT + CTRL + K" ''hl.dsp.window.move({ direction = "u" })'')
    (mkBind "SUPER + SHIFT + CTRL + J" ''hl.dsp.window.move({ direction = "d" })'')

    # Resize windows
    (mkBindRepeat "SUPER + SHIFT + right" "hl.dsp.window.resize({ x = 30, y = 0, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + left" "hl.dsp.window.resize({ x = -30, y = 0, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + up" "hl.dsp.window.resize({ x = 0, y = -30, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + down" "hl.dsp.window.resize({ x = 0, y = 30, relative = true })")

    # Resize windows with hjkl keys
    (mkBindRepeat "SUPER + SHIFT + l" "hl.dsp.window.resize({ x = 30, y = 0, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + h" "hl.dsp.window.resize({ x = -30, y = 0, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + k" "hl.dsp.window.resize({ x = 0, y = -30, relative = true })")
    (mkBindRepeat "SUPER + SHIFT + j" "hl.dsp.window.resize({ x = 0, y = 30, relative = true })")

    # Functional keybinds
    (mkBindLocked "XF86AudioMute" ''hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput")'')
    (mkBindLocked "XF86AudioMicMute" ''hl.dsp.exec_cmd("noctalia-shell ipc call volume muteInput")'')
    (mkBindLocked "XF86AudioPlay" ''hl.dsp.exec_cmd("noctalia-shell ipc call media play")'')
    (mkBindLocked "XF86AudioPause" ''hl.dsp.exec_cmd("noctalia-shell ipc call media pause")'')
    (mkBindLocked "XF86AudioNext" ''hl.dsp.exec_cmd("noctalia-shell ipc call media next")'')
    (mkBindLocked "XF86AudioPrev" ''hl.dsp.exec_cmd("noctalia-shell ipc call media previous")'')

    # Functional keybinds
    (mkBindLockedRepeat "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease")'')
    (mkBindLockedRepeat "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("noctalia-shell ipc call volume increase")'')
    (mkBindLockedRepeat "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease")'')
    (mkBindLockedRepeat "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase")'')

    # Move/Resize windows with mainMod + LMB/RMB and dragging
    (mkBindMouse "SUPER + mouse:272" "hl.dsp.window.drag()")
    (mkBindMouse "SUPER + mouse:273" "hl.dsp.window.resize()")

    # Enter mouse mode
    (mkBind "SUPER + M" ''hl.dsp.submap("mouse-mode")'')
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
        (mkBind "SUPER + ${ws}" "hl.dsp.focus({ workspace = ${toString (x + 1)} })")
        (mkBind "SUPER + SHIFT + ${ws}" "hl.dsp.window.move({ workspace = ${toString (x + 1)} })")
        (mkBind "SUPER + CTRL + ${ws}" "hl.dsp.window.move({ workspace = ${toString (x + 1)}, follow = false })")
      ]
    ) 10
  ))
  ++ lib.optional config.programs.rbw.enable (
    mkBind "SUPER + ALT + U" ''hl.dsp.exec_cmd("${launcher} rbw")''
  )
  ++ lib.optional config.programs.translate-shell.enable (
    mkBind "SUPER + ALT + T" ''hl.dsp.exec_cmd("${launcher} translate")''
  )
  ++ lib.optionals config.programs.tmux.enable [
    (mkBind "SUPER + T" ''hl.dsp.exec_cmd("${terminal} -e tmux")'')
    (mkBind "SUPER + SHIFT + T" ''hl.dsp.exec_cmd("${launcher} tmux")'')
  ]
  ++ lib.optionals osConfig.programs.steam.enable [
    (mkBind "SUPER + SHIFT + G" ''hl.dsp.exec_cmd("${gamespace}")'')
    (mkBind "SUPER + CTRL + G" ''hl.dsp.exec_cmd("${launcher} game")'')
  ];

  define_submap = {
    _args = [
      "mouse-mode"
      (mkLuaInline ''
        function()
          hl.bind("H", hl.dsp.exec_cmd("wlrctl pointer move -10 0"), { repeating = true })
          hl.bind("L", hl.dsp.exec_cmd("wlrctl pointer move 10 0"), { repeating = true })
          hl.bind("K", hl.dsp.exec_cmd("wlrctl pointer move 0 -10"), { repeating = true })
          hl.bind("J", hl.dsp.exec_cmd("wlrctl pointer move 0 10"), { repeating = true })
          hl.bind("SHIFT + H", hl.dsp.exec_cmd("wlrctl pointer move -100 0"), { repeating = true })
          hl.bind("SHIFT + L", hl.dsp.exec_cmd("wlrctl pointer move 100 0"), { repeating = true })
          hl.bind("SHIFT + K", hl.dsp.exec_cmd("wlrctl pointer move 0 -100"), { repeating = true })
          hl.bind("SHIFT + J", hl.dsp.exec_cmd("wlrctl pointer move 0 100"), { repeating = true })
          hl.bind("comma", hl.dsp.exec_cmd("wlrctl pointer click left"))
          hl.bind("period", hl.dsp.exec_cmd("wlrctl pointer click right"))
          hl.bind("escape", hl.dsp.submap("reset"))
          hl.bind("Q", hl.dsp.submap("reset"))
        end
      '')
    ];
  };
}
