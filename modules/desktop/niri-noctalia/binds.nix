{
  osConfig,
  config,
  lib,
  pkgs,
  opts,
  launcher,
  clip-manager,
  screenshot,
  autoclicker,
  getExe,
  ...
}:
let
  terminal =
    if ((opts.terminal == "foot") && (opts.foot.server or false)) then
      "footclient"
    else
      "${opts.terminal}";
  fileManager =
    if (opts.terminal == "kitty") then
      [
        terminal
        "--class"
        "terminalFileManager"
        "-e"
        opts.terminalFileManager
      ]
    else if (opts.terminal == "foot") then
      [
        terminal
        "--app-id"
        "terminalFileManager"
        "-e"
        opts.terminalFileManager
      ]
    else
      [
        terminal
        "-e"
        opts.terminalFileManager
      ];
  editor =
    if (opts.terminal == "kitty") then
      [
        terminal
        "--class"
        "editor"
        "-e"
        opts.editor
      ]
    else if (opts.terminal == "foot") then
      [
        terminal
        "--app-id"
        "editor"
        "-e"
        opts.editor
      ]
    else
      [
        terminal
        "-e"
        opts.editor
      ];
  browser = opts.browser;
in
{
  "Mod+Shift+Slash".action."show-hotkey-overlay" = { };

  "Mod+Return" = {
    action.spawn = terminal;
    hotkey-overlay.title = "Launch terminal: ${opts.terminal}";
  };
  "Mod+F" = {
    action.spawn = fileManager;
    hotkey-overlay.title = "Launch file manager: ${opts.terminalFileManager}";
  };
  "Mod+E" = {
    action.spawn = editor;
    hotkey-overlay.title = "Launch editor: ${opts.editor}";
  };
  "Mod+B" = {
    action.spawn = browser;
    hotkey-overlay.title = "Launch browser: ${opts.browser}";
  };

  "Mod+Space" = {
    action.spawn = [
      "${launcher}"
      "drun"
    ];
    hotkey-overlay.title = "Launch application menu";
  };
  "Mod+Ctrl+T" = {
    action.spawn = [
      "${launcher}"
      "theme"
    ];
    hotkey-overlay.title = "Select theme";
  };
  "Mod+Alt+S" = {
    action.spawn = [
      "${launcher}"
      "spec"
    ];
    hotkey-overlay.title = "Select specialisation";
  };
  "Mod+V" = {
    action.spawn = "${clip-manager}";
    hotkey-overlay.title = "Clipboard manager";
  };

  "Mod+Shift+A" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "controlCenter"
      "toggle"
    ];
    hotkey-overlay.title = "Open control center";
  };
  "Mod+Shift+Q" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "notifications"
      "toggleHistory"
    ];
    hotkey-overlay.title = "Open notification panel";
  };
  "Mod+Ctrl+W" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "wallpaper"
      "toggle"
    ];
    hotkey-overlay.title = "Select wallpaper";
  };
  "Mod+Shift+W" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "wallpaper"
      "random"
    ];
    hotkey-overlay.title = "Random wallpaper";
  };
  "Ctrl+Escape" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "bar"
      "toggle"
    ];
    hotkey-overlay.title = "Toggle bar";
  };
  "Mod+Alt+L" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "lockScreen"
      "lock"
    ];
    hotkey-overlay.title = "Lock screen";
  };
  "Mod+Backspace" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "sessionMenu"
      "toggle"
    ];
    hotkey-overlay.title = "Session menu";
  };

  "Mod+F10" = {
    action.spawn = [
      "${terminal}"
      "-e"
      "${getExe pkgs.btop}"
    ];
    hotkey-overlay.title = "Open system monitor: btop";
  };
  "Mod+F11" = {
    action.spawn-sh = "pkill hyprpicker || hyprpicker --autocopy --format=hex";
    hotkey-overlay.title = "Color picker";
  };
  "Mod+F12" = {
    action.spawn-sh = "kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40";
    hotkey-overlay.title = "Toggle autoclicker";
  };

  "XF86AudioRaiseVolume" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "volume"
      "increase"
    ];
    allow-when-locked = true;
  };
  "XF86AudioLowerVolume" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "volume"
      "decrease"
    ];
    allow-when-locked = true;
  };
  "XF86AudioMute" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "volume"
      "muteOutput"
    ];
    allow-when-locked = true;
  };
  "XF86AudioMicMute" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "volume"
      "muteInput"
    ];
    allow-when-locked = true;
  };

  "XF86AudioPlay" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "media"
      "play"
    ];
    allow-when-locked = true;
  };
  "XF86AudioStop" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "media"
      "pause"
    ];
    allow-when-locked = true;
  };
  "XF86AudioPrev" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "media"
      "previous"
    ];
    allow-when-locked = true;
  };
  "XF86AudioNext" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "media"
      "next"
    ];
    allow-when-locked = true;
  };

  "XF86MonBrightnessUp" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "brightness"
      "increase"
    ];
    allow-when-locked = true;
  };
  "XF86MonBrightnessDown" = {
    action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "brightness"
      "decrease"
    ];
    allow-when-locked = true;
  };

  "Mod+Tab" = {
    action."toggle-overview" = { };
    repeat = false;
  };

  "Mod+Q" = {
    action."close-window" = { };
    repeat = false;
  };

  "Mod+Left".action."focus-column-left" = { };
  "Mod+Down".action."focus-window-down" = { };
  "Mod+Up".action."focus-window-up" = { };
  "Mod+Right".action."focus-column-right" = { };
  "Mod+H".action."focus-column-left" = { };
  "Mod+J".action."focus-window-down" = { };
  "Mod+K".action."focus-window-up" = { };
  "Mod+L".action."focus-column-right" = { };

  "Mod+Ctrl+Left".action."move-column-left" = { };
  "Mod+Ctrl+Down".action."move-window-down" = { };
  "Mod+Ctrl+Up".action."move-window-up" = { };
  "Mod+Ctrl+Right".action."move-column-right" = { };
  "Mod+Ctrl+H".action."move-column-left" = { };
  "Mod+Ctrl+J".action."move-window-down" = { };
  "Mod+Ctrl+K".action."move-window-up" = { };
  "Mod+Ctrl+L".action."move-column-right" = { };

  "Mod+Home".action."focus-column-first" = { };
  "Mod+End".action."focus-column-last" = { };
  "Mod+Ctrl+Home".action."move-column-to-first" = { };
  "Mod+Ctrl+End".action."move-column-to-last" = { };

  "Mod+Shift+Left".action."focus-monitor-left" = { };
  "Mod+Shift+Down".action."focus-monitor-down" = { };
  "Mod+Shift+Up".action."focus-monitor-up" = { };
  "Mod+Shift+Right".action."focus-monitor-right" = { };
  "Mod+Shift+H".action."focus-monitor-left" = { };
  "Mod+Shift+J".action."focus-monitor-down" = { };
  "Mod+Shift+K".action."focus-monitor-up" = { };
  "Mod+Shift+L".action."focus-monitor-right" = { };

  "Mod+Shift+Ctrl+Left".action."move-column-to-monitor-left" = { };
  "Mod+Shift+Ctrl+Down".action."move-column-to-monitor-down" = { };
  "Mod+Shift+Ctrl+Up".action."move-column-to-monitor-up" = { };
  "Mod+Shift+Ctrl+Right".action."move-column-to-monitor-right" = { };
  "Mod+Shift+Ctrl+H".action."move-column-to-monitor-left" = { };
  "Mod+Shift+Ctrl+J".action."move-column-to-monitor-down" = { };
  "Mod+Shift+Ctrl+K".action."move-column-to-monitor-up" = { };
  "Mod+Shift+Ctrl+L".action."move-column-to-monitor-right" = { };

  "Mod+Page_Down".action."focus-workspace-down" = { };
  "Mod+Page_Up".action."focus-workspace-up" = { };
  "Mod+U".action."focus-workspace-down" = { };
  "Mod+I".action."focus-workspace-up" = { };
  "Mod+Ctrl+Page_Down".action."move-column-to-workspace-down" = { };
  "Mod+Ctrl+Page_Up".action."move-column-to-workspace-up" = { };
  "Mod+Ctrl+U".action."move-column-to-workspace-down" = { };
  "Mod+Ctrl+I".action."move-column-to-workspace-up" = { };

  "Mod+Shift+Page_Down".action."move-workspace-down" = { };
  "Mod+Shift+Page_Up".action."move-workspace-up" = { };
  "Mod+Shift+U".action."move-workspace-down" = { };
  "Mod+Shift+I".action."move-workspace-up" = { };

  "Mod+WheelScrollDown" = {
    action."focus-workspace-down" = { };
    cooldown-ms = 150;
  };
  "Mod+WheelScrollUp" = {
    action."focus-workspace-up" = { };
    cooldown-ms = 150;
  };
  "Mod+Ctrl+WheelScrollDown" = {
    action."move-column-to-workspace-down" = { };
    cooldown-ms = 150;
  };
  "Mod+Ctrl+WheelScrollUp" = {
    action."move-column-to-workspace-up" = { };
    cooldown-ms = 150;
  };

  "Mod+WheelScrollRight".action."focus-column-right" = { };
  "Mod+WheelScrollLeft".action."focus-column-left" = { };
  "Mod+Ctrl+WheelScrollRight".action."move-column-right" = { };
  "Mod+Ctrl+WheelScrollLeft".action."move-column-left" = { };

  "Mod+Shift+WheelScrollDown".action."focus-column-right" = { };
  "Mod+Shift+WheelScrollUp".action."focus-column-left" = { };
  "Mod+Ctrl+Shift+WheelScrollDown".action."move-column-right" = { };
  "Mod+Ctrl+Shift+WheelScrollUp".action."move-column-left" = { };

  "Mod+1".action."focus-workspace" = 1;
  "Mod+2".action."focus-workspace" = 2;
  "Mod+3".action."focus-workspace" = 3;
  "Mod+4".action."focus-workspace" = 4;
  "Mod+5".action."focus-workspace" = 5;
  "Mod+6".action."focus-workspace" = 6;
  "Mod+7".action."focus-workspace" = 7;
  "Mod+8".action."focus-workspace" = 8;
  "Mod+9".action."focus-workspace" = 9;
  "Mod+Ctrl+1".action."move-column-to-workspace" = 1;
  "Mod+Ctrl+2".action."move-column-to-workspace" = 2;
  "Mod+Ctrl+3".action."move-column-to-workspace" = 3;
  "Mod+Ctrl+4".action."move-column-to-workspace" = 4;
  "Mod+Ctrl+5".action."move-column-to-workspace" = 5;
  "Mod+Ctrl+6".action."move-column-to-workspace" = 6;
  "Mod+Ctrl+7".action."move-column-to-workspace" = 7;
  "Mod+Ctrl+8".action."move-column-to-workspace" = 8;
  "Mod+Ctrl+9".action."move-column-to-workspace" = 9;

  "Mod+BracketLeft".action."consume-or-expel-window-left" = { };
  "Mod+BracketRight".action."consume-or-expel-window-right" = { };

  "Mod+Comma".action."consume-window-into-column" = { };
  "Mod+Period".action."expel-window-from-column" = { };

  "Mod+R".action."switch-preset-column-width" = { };
  "Mod+Shift+R".action."switch-preset-window-height" = { };
  "Mod+Ctrl+R".action."reset-window-height" = { };
  "Mod+M".action."maximize-column" = { };
  "Alt+Return".action."fullscreen-window" = { };

  "Mod+Shift+M".action."expand-column-to-available-width" = { };

  "Mod+C".action."center-column" = { };

  "Mod+Ctrl+C".action."center-visible-columns" = { };

  "Mod+Minus".action.set-column-width = "-10%";
  "Mod+Equal".action.set-column-width = "+10%";

  "Mod+Shift+Minus".action.set-window-height = "-10%";
  "Mod+Shift+Equal".action.set-window-height = "+10%";

  "Mod+W".action."toggle-window-floating" = { };
  "Mod+Shift+F".action."switch-focus-between-floating-and-tiling" = { };

  "Mod+T".action."toggle-column-tabbed-display" = { };

  "Mod+P" = {
    action.spawn = [
      "${screenshot}"
      "s"
    ];
    hotkey-overlay.title = "Screenshot (select area)";
  };
  "Mod+Shift+P" = {
    action.spawn = [
      "${screenshot}"
      "a"
    ];
    hotkey-overlay.title = "Screenshot (all monitors)";
  };
  "Mod+Ctrl+P" = {
    action.spawn = [
      "${screenshot}"
      "o"
    ];
    hotkey-overlay.title = "OCR capture (select area)";
  };
}
// lib.optionalAttrs config.programs.tmux.enable {
  "Mod+Shift+T" = {
    action.spawn = [
      "${launcher}"
      "tmux"
    ];
    hotkey-overlay.title = "Launch tmux sessions";
  };
}
// lib.optionalAttrs (opts.rbw.rofi-rbw or false) {
  "Mod+Alt+U" = {
    action.spawn = [
      "${launcher}"
      "rbw"
    ];
    hotkey-overlay.title = "Launch password manager";
  };
}
// lib.optionalAttrs osConfig.programs.steam.enable {
  "Mod+Shift+G" = {
    hotkey-overlay.title = "Game launcher";
    action.spawn = [
      "${launcher}"
      "game"
    ];
  };
}
// opts.niri.settings.binds or { }
