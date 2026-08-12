{
  config,
  lib,
  file-manager,
  autoclicker,
  getExe,
  ...
}:
let
  inherit (lib) optionalAttrs;
  termInfo = import ../shared/misc/terminal.nix { inherit config; };
  terminal = termInfo.exe;
  fileManager = "${file-manager} ${config.defaultPrograms.fileManager}";
  editor = ''${terminal} ${termInfo.classFlag} "editor" -e ${config.defaultPrograms.editor}'';
  browser = config.defaultPrograms.browser;
in
{
  "Mod+Shift+Slash" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "kenn/keybind-cheatsheet:cheatsheet"
    ];
  };

  "Mod+Return" = {
    spawn = terminal;
  };
  "Mod+F" = {
    spawn-sh = fileManager;
  };
  "Mod+E" = {
    spawn-sh = editor;
  };
  "Mod+B" = {
    spawn = browser;
  };

  "Mod+Space" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "launcher"
    ];
  };
  "Mod+V" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "clipboard"
    ];
  };

  "Mod+Shift+A" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "control-center"
    ];
  };
  "Mod+Shift+Q" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "control-center"
      "notifications"
    ];
  };
  "Mod+Ctrl+Q" = {
    spawn = [
      "noctalia"
      "msg"
      "notification-clear-history"
    ];
  };
  "Mod+Alt+Q" = {
    spawn = [
      "noctalia"
      "msg"
      "notification-dnd-toggle"
    ];
  };
  "Mod+Shift+W" = {
    spawn = [
      "noctalia"
      "msg"
      "wallpaper-random"
    ];
  };
  "Mod+Ctrl+W" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "wallpaper"
    ];
  };
  "Ctrl+Escape" = {
    spawn = [
      "noctalia"
      "msg"
      "bar-toggle"
    ];
  };
  "Mod+Alt+L" = {
    spawn = [
      "noctalia"
      "msg"
      "session"
      "lock"
    ];
  };
  "Mod+Backspace" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "session"
    ];
  };

  "Mod+F10" = {
    spawn = [
      "${terminal}"
      "-e"
      "btop"
    ];
  };
  "Mod+F12" = {
    spawn-sh = "kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${autoclicker} --cps 40";
  };

  "XF86AudioRaiseVolume" = {
    spawn = [
      "noctalia"
      "msg"
      "volume-up"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioLowerVolume" = {
    spawn = [
      "noctalia"
      "msg"
      "volume-down"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioMute" = {
    spawn = [
      "noctalia"
      "msg"
      "volume-mute"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioMicMute" = {
    spawn = [
      "noctalia"
      "msg"
      "mic-mute"
    ];
    _props.allow-when-locked = true;
  };

  "XF86AudioPlay" = {
    spawn = [
      "noctalia"
      "msg"
      "media"
      "toggle"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioStop" = {
    spawn = [
      "noctalia"
      "msg"
      "media"
      "stop"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioPrev" = {
    spawn = [
      "noctalia"
      "msg"
      "media"
      "previous"
    ];
    _props.allow-when-locked = true;
  };
  "XF86AudioNext" = {
    spawn = [
      "noctalia"
      "msg"
      "media"
      "next"
    ];
    _props.allow-when-locked = true;
  };

  "XF86MonBrightnessUp" = {
    spawn = [
      "noctalia"
      "msg"
      "brightness-up"
    ];
    _props.allow-when-locked = true;
  };
  "XF86MonBrightnessDown" = {
    spawn = [
      "noctalia"
      "msg"
      "brightness-down"
    ];
    _props.allow-when-locked = true;
  };

  "Mod+Tab" = {
    "toggle-overview" = { };
    _props.repeat = false;
  };

  "Mod+Q" = {
    "close-window" = { };
    _props.repeat = false;
  };

  "Mod+Left"."focus-column-left" = { };
  "Mod+Down"."focus-window-down" = { };
  "Mod+Up"."focus-window-up" = { };
  "Mod+Right"."focus-column-right" = { };
  "Mod+H"."focus-column-left" = { };
  "Mod+J"."focus-window-down" = { };
  "Mod+K"."focus-window-up" = { };
  "Mod+L"."focus-column-right" = { };

  "Mod+Ctrl+Left"."move-column-left" = { };
  "Mod+Ctrl+Down"."move-window-down" = { };
  "Mod+Ctrl+Up"."move-window-up" = { };
  "Mod+Ctrl+Right"."move-column-right" = { };
  "Mod+Ctrl+H"."move-column-left" = { };
  "Mod+Ctrl+J"."move-window-down" = { };
  "Mod+Ctrl+K"."move-window-up" = { };
  "Mod+Ctrl+L"."move-column-right" = { };

  "Mod+Home"."focus-column-first" = { };
  "Mod+End"."focus-column-last" = { };
  "Mod+Ctrl+Home"."move-column-to-first" = { };
  "Mod+Ctrl+End"."move-column-to-last" = { };

  "Mod+Shift+Left"."focus-monitor-left" = { };
  "Mod+Shift+Down"."focus-monitor-down" = { };
  "Mod+Shift+Up"."focus-monitor-up" = { };
  "Mod+Shift+Right"."focus-monitor-right" = { };
  "Mod+Shift+H"."focus-monitor-left" = { };
  "Mod+Shift+J"."focus-monitor-down" = { };
  "Mod+Shift+K"."focus-monitor-up" = { };
  "Mod+Shift+L"."focus-monitor-right" = { };

  "Mod+Shift+Ctrl+Left"."move-column-to-monitor-left" = { };
  "Mod+Shift+Ctrl+Down"."move-column-to-monitor-down" = { };
  "Mod+Shift+Ctrl+Up"."move-column-to-monitor-up" = { };
  "Mod+Shift+Ctrl+Right"."move-column-to-monitor-right" = { };
  "Mod+Shift+Ctrl+H"."move-column-to-monitor-left" = { };
  "Mod+Shift+Ctrl+J"."move-column-to-monitor-down" = { };
  "Mod+Shift+Ctrl+K"."move-column-to-monitor-up" = { };
  "Mod+Shift+Ctrl+L"."move-column-to-monitor-right" = { };

  "Mod+Page_Down"."focus-workspace-down" = { };
  "Mod+Page_Up"."focus-workspace-up" = { };
  "Mod+U"."focus-workspace-down" = { };
  "Mod+I"."focus-workspace-up" = { };
  "Mod+Ctrl+Page_Down"."move-column-to-workspace-down" = { };
  "Mod+Ctrl+Page_Up"."move-column-to-workspace-up" = { };
  "Mod+Ctrl+U"."move-column-to-workspace-down" = { };
  "Mod+Ctrl+I"."move-column-to-workspace-up" = { };

  "Mod+Shift+Page_Down"."move-workspace-down" = { };
  "Mod+Shift+Page_Up"."move-workspace-up" = { };
  "Mod+Shift+U"."move-workspace-down" = { };
  "Mod+Shift+I"."move-workspace-up" = { };

  "Mod+WheelScrollDown" = {
    "focus-workspace-down" = { };
    _props.cooldown-ms = 150;
  };
  "Mod+WheelScrollUp" = {
    "focus-workspace-up" = { };
    _props.cooldown-ms = 150;
  };
  "Mod+Ctrl+WheelScrollDown" = {
    "move-column-to-workspace-down" = { };
    _props.cooldown-ms = 150;
  };
  "Mod+Ctrl+WheelScrollUp" = {
    "move-column-to-workspace-up" = { };
    _props.cooldown-ms = 150;
  };

  "Mod+WheelScrollRight"."focus-column-right" = { };
  "Mod+WheelScrollLeft"."focus-column-left" = { };
  "Mod+Ctrl+WheelScrollRight"."move-column-right" = { };
  "Mod+Ctrl+WheelScrollLeft"."move-column-left" = { };

  "Mod+Shift+WheelScrollDown"."focus-column-right" = { };
  "Mod+Shift+WheelScrollUp"."focus-column-left" = { };
  "Mod+Ctrl+Shift+WheelScrollDown"."move-column-right" = { };
  "Mod+Ctrl+Shift+WheelScrollUp"."move-column-left" = { };

  "Mod+1"."focus-workspace" = 1;
  "Mod+2"."focus-workspace" = 2;
  "Mod+3"."focus-workspace" = 3;
  "Mod+4"."focus-workspace" = 4;
  "Mod+5"."focus-workspace" = 5;
  "Mod+6"."focus-workspace" = 6;
  "Mod+7"."focus-workspace" = 7;
  "Mod+8"."focus-workspace" = 8;
  "Mod+9"."focus-workspace" = 9;
  "Mod+Ctrl+1"."move-column-to-workspace" = 1;
  "Mod+Ctrl+2"."move-column-to-workspace" = 2;
  "Mod+Ctrl+3"."move-column-to-workspace" = 3;
  "Mod+Ctrl+4"."move-column-to-workspace" = 4;
  "Mod+Ctrl+5"."move-column-to-workspace" = 5;
  "Mod+Ctrl+6"."move-column-to-workspace" = 6;
  "Mod+Ctrl+7"."move-column-to-workspace" = 7;
  "Mod+Ctrl+8"."move-column-to-workspace" = 8;
  "Mod+Ctrl+9"."move-column-to-workspace" = 9;

  "Mod+BracketLeft"."consume-or-expel-window-left" = { };
  "Mod+BracketRight"."consume-or-expel-window-right" = { };

  "Mod+Comma"."consume-window-into-column" = { };
  "Mod+Period"."expel-window-from-column" = { };

  "Mod+R"."switch-preset-column-width" = { };
  "Mod+Shift+R"."switch-preset-window-height" = { };
  "Mod+Ctrl+R"."reset-window-height" = { };
  "Mod+M"."maximize-column" = { };
  "Alt+Return"."fullscreen-window" = { };

  "Mod+Shift+M"."expand-column-to-available-width" = { };

  "Mod+C"."center-column" = { };

  "Mod+Ctrl+C"."center-visible-columns" = { };

  "Mod+Minus".set-column-width = "-10%";
  "Mod+Equal".set-column-width = "+10%";

  "Mod+Shift+Minus".set-window-height = "-10%";
  "Mod+Shift+Equal".set-window-height = "+10%";

  "Mod+W"."toggle-window-floating" = { };
  "Mod+Shift+F"."switch-focus-between-floating-and-tiling" = { };

  "Mod+T"."toggle-column-tabbed-display" = { };

  "Mod+Print" = {
    spawn = [
      "noctalia"
      "msg"
      "screenshot-region"
    ];
  };
  "Mod+Shift+Print" = {
    spawn = [
      "noctalia"
      "msg"
      "screenshot-fullscreen"
      "pick"
    ];
  };
  "Mod+Ctrl+Print" = {
    spawn-sh = "touch /tmp/noctalia-screenshot-ocr && noctalia msg screenshot-region";
  };
}
// optionalAttrs config.programs.tmux.enable {
  "Mod+T" = {
    spawn = [
      "${terminal}"
      "-e"
      "tmux"
    ];
  };
}
// optionalAttrs config.programs.password-store.enable {
  "Mod+Shift+P" = {
    spawn = [
      "noctalia"
      "msg"
      "panel-toggle"
      "launcher"
      "/pass"
    ];
  };
}
