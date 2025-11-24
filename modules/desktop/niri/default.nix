{
  lib,
  pkgs,
  opts,
  ...
}:
{
  imports = [
    ./programs/rofi
    ./programs/swayidle
    ./programs/swaylock
    ./programs/swaync
    ./programs/swww
    ./programs/waybar
    ./programs/wlogout
    ./scripts
  ];

  systemd.user.services.random-wall = {
    description = "Randomly change wallpaper";
    startAt = "hourly";
    script = "${lib.getExe (import ./scripts/random-wall.nix { inherit pkgs opts; })}";
    serviceConfig = {
      Type = "oneshot";
    };
  };

  programs.niri = {
    enable = true;
  };

  home-manager.sharedModules = [
    (
      {
        osConfig,
        config,
        pkgs,
        ...
      }:
      let
        inherit (lib) getExe getExe';

        terminal =
          if (opts.terminal == "foot") then
            if (opts.foot.server or false) then "${getExe' pkgs.foot "footclient"}" else "${getExe pkgs.foot}"
          else
            "${getExe pkgs.${opts.terminal}}";
        fileManager =
          if (opts.terminal == "kitty") then
            ''${terminal} --class \"terminalFileManager\" -e ${opts.terminalFileManager}''
          else if (opts.terminal == "foot") then
            ''${terminal} --app-id \"terminalFileManager\" -e ${opts.terminalFileManager}''
          else
            ''${terminal} -e ${opts.terminalFileManager}'';
        editor =
          if (opts.terminal == "kitty") then
            ''${terminal} --class \"editor\" -e ${opts.editor}''
          else if (opts.terminal == "foot") then
            ''${terminal} --app-id \"editor\" -e ${opts.editor}''
          else
            ''${terminal} -e ${opts.editor}'';
        browser = opts.browser;

        autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };

        niriConfig = ''
          ${lib.concatMapStringsSep "\n" (
            output:
            lib.optionalString ((output.name or "") != "") ''
              output "${output.name}" {
                ${lib.optionalString (output.off or false) "off"}
                ${lib.optionalString ((output.mode or "") != "") ''mode "${output.mode}"''}
                ${lib.optionalString ((output.scale or null) != null) ''scale ${builtins.toJSON output.scale}''}
                ${lib.optionalString ((output.transform or "") != "") ''transform "${output.transform}"''}
                ${
                  lib.optionalString (
                    (((output.position.x or null) != null) && ((output.position.y or null) != null))
                  ) ''position x=${toString output.position.x} y=${toString output.position.y}''
                } 
                ${lib.optionalString (output.variable-refresh-rate or false) "variable-refresh-rate"}
                ${lib.optionalString (output.focus-at-startup or false) "focus-at-startup"}
                ${lib.optionalString (
                  (output.backdrop-color or "") != ""
                ) ''backdrop-color "${output.backdrop-color}"''}
                ${lib.optionalString ((output.hot-corners or null) != null) ''
                  hot-corners {
                    ${lib.optionalString (output.hot-corners.off or false) "off"}
                    ${lib.optionalString (output.hot-corners.top-left or false) "top-left"}
                    ${lib.optionalString (output.hot-corners.top-right or false) "top-right"}
                    ${lib.optionalString (output.hot-corners.bottom-left or false) "bottom-left"}
                    ${lib.optionalString (output.hot-corners.bottom-right or false) "bottom-right"}
                  }
                ''}
              }
            ''
          ) opts.niri.output}

          input {
              touchpad {
                  tap
                  natural-scroll
              }
          }

          environment {
              ELECTRON_OZONE_PLATFORM "wayland"
              QT_QPA_PLATFORM "wayland"
              QT_QPA_PLATFORMTHEME "qt6ct"
          }

          layout {
              gaps 10
              background-color "transparent"
              center-focused-column "never"
              preset-column-widths {
                  proportion 0.33333
                  proportion 0.5
                  proportion 0.66667
              }
              default-column-width { proportion 0.5; }
              focus-ring {
                  width 2
                  ${lib.optionalString (
                    (opts.theme or "") == "catppuccin-mocha"
                  ) ''active-gradient from="#ca9ee6" to="#f2d5cf" angle=45''}
                  ${lib.optionalString (
                    (opts.theme or "") == "catppuccin-mocha"
                  ) ''inactive-gradient from="#b4befe" to="#6c7086" angle=45''}
                  }
              border {
                  off
              }
              shadow {
                  softness 30
                  spread 5
                  offset x=0 y=5
                  ${lib.optionalString ((opts.theme or "") == "catppuccin-mocha") ''color "#11111b"''}
              }
          }

          layer-rule {
              match namespace="swww-daemon"
              place-within-backdrop true
          }

          overview {
              zoom 0.5
              workspace-shadow {
                  off
              }
          }

          window-rule {
              geometry-corner-radius 10
              clip-to-geometry true
          }

          window-rule {
              match app-id=r#"firefox"# title="^Picture-in-Picture$"
              open-floating true
          }

          window-rule {
              draw-border-with-background false
              match app-id="kitty"
              match app-id="foot"
              match app-id="footclient"
              match app-id="editor"
              match app-id="terminalFileManager"
              match app-id="Spotify"
              match app-id="steam"
              match app-id="code"
              match app-id="obsidian"
              opacity 0.95
          }

          prefer-no-csd

          hotkey-overlay {
              skip-at-startup
              hide-not-bound
          }

          screenshot-path "~/pic/screenshots/screenshot from %Y-%m-%d %H-%M-%S.png"

          spawn-at-startup "waybar"
          spawn-at-startup "swaync"
          spawn-at-startup "fcitx5"
          spawn-sh-at-startup "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=gnome"
          spawn-sh-at-startup "systemctl --user stop xdg-desktop-portal.service"
          spawn-sh-at-startup "systemctl --user start xdg-desktop-portal.service"
          spawn-sh-at-startup "systemctl --user restart lxqt-policykit-agent.service"
          spawn-sh-at-startup "wl-clipboard-history -t"
          spawn-sh-at-startup "wl-paste --type text --watch cliphist store"
          spawn-sh-at-startup "wl-paste --type image --watch cliphist store"
          spawn-sh-at-startup "rm $XDG_CACHE_HOME/cliphist/db"
          spawn-sh-at-startup "nm-applet --indicator"
          spawn-sh-at-startup "sleep 2 && pamixer --set-volume 50"
          spawn-sh-at-startup "${./scripts/randomwallctl.sh} -r"
          ${lib.optionalString osConfig.services.power-profiles-daemon.enable ''spawn-sh-at-startup "powermodectl -r"''}
          ${lib.optionalString (
            (opts.terminal == "foot") && (opts.foot.server or false)
          ) ''spawn-sh-at-startup "${getExe pkgs.foot} --server"''}

          binds {
              Mod+Shift+Slash { show-hotkey-overlay; }

              Mod+Return hotkey-overlay-title="Launch terminal: ${opts.terminal}" { spawn "${terminal}"; }
              Mod+F hotkey-overlay-title="Launch file manager: ${opts.terminalFileManager}" { spawn-sh "${fileManager}"; }
              Mod+E hotkey-overlay-title="Launch editor: ${opts.editor}" { spawn-sh "${editor}"; }
              Mod+B hotkey-overlay-title="Launch browser: ${opts.browser}" { spawn "${browser}"; }
              Ctrl+Alt+Delete hotkey-overlay-title="Open system monitor: btop" { spawn-sh "${terminal} -e ${getExe pkgs.btop}"; }

              Mod+Space hotkey-overlay-title="Launch application menu" { spawn-sh "launcher drun"; }
              Mod+Shift+W hotkey-overlay-title="Launch wallpaper menu" { spawn-sh "launcher wallpaper"; }

              ${lib.optionalString (config.programs.tmux.enable or false) ''
                Mod+Shift+T hotkey-overlay-title="Launch tmux sessions" { spawn-sh "launcher tmux"; }
              ''}
              ${lib.optionalString (opts.rbw.rofi-rbw or false) ''
                Mod+Alt+U hotkey-overlay-title="Launch password manager" { spawn-sh "launcher rbw"; }
              ''}
              ${lib.optionalString (osConfig.programs.steam.enable or false) ''
                Mod+G hotkey-overlay-title="Game launcher" { spawn-sh "launcher games"; }
              ''}

              Mod+Backspace hotkey-overlay-title="Power menu" { spawn-sh "pkill -x wlogout || wlogout -b 4"; }
              Mod+Shift+Q hotkey-overlay-title="Open notification panel" { spawn-sh "swaync-client -t -sw"; }
              Ctrl+Escape hotkey-overlay-title="Toggle waybar" { spawn-sh "pkill waybar || waybar"; }

              Mod+F8 hotkey-overlay-title="Toggle autoclicker" { spawn-sh "kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"; }
              Mod+F9 hotkey-overlay-title="Enable night mode" { spawn-sh "wlsunset -T 6500"; }
              Mod+F10 hotkey-overlay-title="Disable night mode" { spawn-sh "pkill wlsunset"; }

              Mod+V hotkey-overlay-title="Clipboard manager" { spawn-sh "bash ${./scripts}/clip-manager.sh"; }
              Mod+Ctrl+W hotkey-overlay-title="Random wallpaper" { spawn-sh "random-wall"; }

              XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"; }
              XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
              XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
              XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

              XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
              XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
              XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
              XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

              XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
              XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

              Mod+Tab repeat=false { toggle-overview; }

              Mod+Q repeat=false { close-window; }

              Mod+Left  { focus-column-left; }
              Mod+Down  { focus-window-down; }
              Mod+Up    { focus-window-up; }
              Mod+Right { focus-column-right; }
              Mod+H     { focus-column-left; }
              Mod+J     { focus-window-down; }
              Mod+K     { focus-window-up; }
              Mod+L     { focus-column-right; }

              Mod+Ctrl+Left  { move-column-left; }
              Mod+Ctrl+Down  { move-window-down; }
              Mod+Ctrl+Up    { move-window-up; }
              Mod+Ctrl+Right { move-column-right; }
              Mod+Ctrl+H     { move-column-left; }
              Mod+Ctrl+J     { move-window-down; }
              Mod+Ctrl+K     { move-window-up; }
              Mod+Ctrl+L     { move-column-right; }

              Mod+Home { focus-column-first; }
              Mod+End  { focus-column-last; }
              Mod+Ctrl+Home { move-column-to-first; }
              Mod+Ctrl+End  { move-column-to-last; }

              Mod+Shift+Left  { focus-monitor-left; }
              Mod+Shift+Down  { focus-monitor-down; }
              Mod+Shift+Up    { focus-monitor-up; }
              Mod+Shift+Right { focus-monitor-right; }
              Mod+Shift+H     { focus-monitor-left; }
              Mod+Shift+J     { focus-monitor-down; }
              Mod+Shift+K     { focus-monitor-up; }
              Mod+Shift+L     { focus-monitor-right; }

              Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
              Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
              Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
              Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
              Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
              Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
              Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
              Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

              Mod+Page_Down      { focus-workspace-down; }
              Mod+Page_Up        { focus-workspace-up; }
              Mod+U              { focus-workspace-down; }
              Mod+I              { focus-workspace-up; }
              Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
              Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
              Mod+Ctrl+U         { move-column-to-workspace-down; }
              Mod+Ctrl+I         { move-column-to-workspace-up; }

              Mod+Shift+Page_Down { move-workspace-down; }
              Mod+Shift+Page_Up   { move-workspace-up; }
              Mod+Shift+U         { move-workspace-down; }
              Mod+Shift+I         { move-workspace-up; }

              Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
              Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
              Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
              Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

              Mod+WheelScrollRight      { focus-column-right; }
              Mod+WheelScrollLeft       { focus-column-left; }
              Mod+Ctrl+WheelScrollRight { move-column-right; }
              Mod+Ctrl+WheelScrollLeft  { move-column-left; }

              Mod+Shift+WheelScrollDown      { focus-column-right; }
              Mod+Shift+WheelScrollUp        { focus-column-left; }
              Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
              Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

              Mod+1 { focus-workspace 1; }
              Mod+2 { focus-workspace 2; }
              Mod+3 { focus-workspace 3; }
              Mod+4 { focus-workspace 4; }
              Mod+5 { focus-workspace 5; }
              Mod+6 { focus-workspace 6; }
              Mod+7 { focus-workspace 7; }
              Mod+8 { focus-workspace 8; }
              Mod+9 { focus-workspace 9; }
              Mod+Ctrl+1 { move-column-to-workspace 1; }
              Mod+Ctrl+2 { move-column-to-workspace 2; }
              Mod+Ctrl+3 { move-column-to-workspace 3; }
              Mod+Ctrl+4 { move-column-to-workspace 4; }
              Mod+Ctrl+5 { move-column-to-workspace 5; }
              Mod+Ctrl+6 { move-column-to-workspace 6; }
              Mod+Ctrl+7 { move-column-to-workspace 7; }
              Mod+Ctrl+8 { move-column-to-workspace 8; }
              Mod+Ctrl+9 { move-column-to-workspace 9; }

              Mod+BracketLeft  { consume-or-expel-window-left; }
              Mod+BracketRight { consume-or-expel-window-right; }

              Mod+Comma  { consume-window-into-column; }
              Mod+Period { expel-window-from-column; }

              Mod+R { switch-preset-column-width; }
              Mod+Shift+R { switch-preset-window-height; }
              Mod+Ctrl+R { reset-window-height; }
              Mod+M { maximize-column; }
              Alt+Return { fullscreen-window; }

              Mod+Shift+M { expand-column-to-available-width; }

              Mod+C { center-column; }

              Mod+Ctrl+C { center-visible-columns; }

              Mod+Minus { set-column-width "-10%"; }
              Mod+Equal { set-column-width "+10%"; }

              Mod+Shift+Minus { set-window-height "-10%"; }
              Mod+Shift+Equal { set-window-height "+10%"; }

              Mod+W       { toggle-window-floating; }
              Mod+Shift+F { switch-focus-between-floating-and-tiling; }

              Mod+T { toggle-column-tabbed-display; }

              Mod+P 	 { screenshot; }
              Mod+Ctrl+P { screenshot-screen; }
              Mod+Alt+P  { screenshot-window; }
          }
        '';
      in
      {
        home.file.".config/niri/config.kdl".text = niriConfig;

        home.packages = with pkgs; [
          cliphist
          libnotify
          brightnessctl
          networkmanagerapplet
          pamixer
          pavucontrol
          playerctl
          wtype
          wlsunset
          wl-clipboard
          xwayland-satellite
        ];

        xdg = {
          enable = true;
          portal = {
            enable = true;
            xdgOpenUsePortal = true;
            extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
            configPackages = [ pkgs.xdg-desktop-portal-gtk ];
            config.common.default = "gtk";
          };
        };

        services.lxqt-policykit-agent = {
          enable = true;
        };
      }
    )
  ];
}
