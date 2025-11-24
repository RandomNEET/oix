{
  lib,
  pkgs,
  opts,
  ...
}:
{
  imports = [
    ./programs/hypridle
    ./programs/hyprlock
    ./programs/rofi
    ./programs/swaync
    ./programs/swww
    ./programs/waybar
    ./programs/wlogout
    ./scripts
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.user.services.random-wall = {
    description = "Randomly change wallpaper";
    startAt = "hourly";
    script = "${lib.getExe (import ./scripts/random-wall.nix { inherit pkgs opts; })}";
    serviceConfig = {
      Type = "oneshot";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.sharedModules =
    let
      inherit (lib) getExe getExe';
    in
    [
      (
        { osConfig, config, ... }:
        {
          home.packages = with pkgs; [
            hyprpicker
            hyprsunset
            cliphist
            grimblast
            swappy
            libnotify
            brightnessctl
            networkmanagerapplet
            pamixer
            pavucontrol
            playerctl
            wtype
            wl-clipboard
            yad
          ];

          xdg = {
            enable = true;
            portal = {
              enable = true;
              extraPortals = with pkgs; [
                xdg-desktop-portal-gtk
              ];
              xdgOpenUsePortal = true;
              configPackages = [ config.wayland.windowManager.hyprland.package ];
              config.hyprland = {
                default = [
                  "hyprland"
                  "gtk"
                ];
                "org.freedesktop.impl.portal.OpenURI" = "gtk";
                "org.freedesktop.impl.portal.FileChooser" = "gtk";
                "org.freedesktop.impl.portal.Print" = "gtk";
              };
            };
            configFile."hypr/icons" = {
              source = ./icons;
              recursive = true;
            };
          };

          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enable = true;
            plugins = with pkgs; [ hyprlandPlugins.hyprexpo ];
            settings = {
              "$mainMod" = "SUPER";
              "$terminal" =
                if (opts.terminal == "foot") then
                  if (opts.foot.server or false) then "${getExe' pkgs.foot "footclient"}" else "${getExe pkgs.foot}"
                else
                  "${getExe pkgs.${opts.terminal}}";
              "$fileManager" =
                if (opts.terminal == "kitty") then
                  ''$terminal --class "terminalFileManager" -e ${opts.terminalFileManager}''
                else if (opts.terminal == "foot") then
                  ''$terminal --app-id "terminalFileManager" -e ${opts.terminalFileManager}''
                else
                  ''$terminal -e ${opts.terminalFileManager}'';
              "$editor" =
                if (opts.terminal == "kitty") then
                  ''$terminal --class "editor" -e ${opts.editor}''
                else if (opts.terminal == "foot") then
                  ''$terminal --app-id "editor" -e ${opts.editor}''
                else
                  ''$terminal -e ${opts.editor}'';
              "$browser" = opts.browser;

              env = [
                "LIBVA_DRIVER_NAME,nvidia"
                "__GLX_VENDOR_LIBRARY_NAME,nvidia"
                "ELECTRON_OZONE_PLATFORM_HINT,auto"
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "GDK_BACKEND,wayland,x11,*"
                "NIXOS_OZONE_WL,1"
                "MOZ_ENABLE_WAYLAND,1"
                "OZONE_PLATFORM,wayland"
                "EGL_PLATFORM,wayland"
                "CLUTTER_BACKEND,wayland"
                "SDL_VIDEODRIVER,wayland"
                "QT_QPA_PLATFORM,wayland;xcb"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "QT_AUTO_SCREEN_SCALE_FACTOR,1"
                "WLR_RENDERER_ALLOW_SOFTWARE,1"
                "NIXPKGS_ALLOW_UNFREE,1"
                "NIXOS_XDG_OPEN_USE_PORTAL,1"
              ];

              exec-once = (
                [
                  "hyprctl dispatch workspace 1"
                  "waybar"
                  "swaync"
                  "nm-applet --indicator"
                  "wl-clipboard-history -t"
                  "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
                  "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
                  "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
                  "sleep 2 && pamixer --set-volume 50"
                  "${./scripts/randomwallctl.sh} -r"
                ]
                ++ lib.optional osConfig.services.power-profiles-daemon.enable "powermodectl -r"
                ++ lib.optional (
                  (opts.terminal == "foot") && (opts.foot.server or false)
                ) "${getExe pkgs.foot} --server"
              );

              input = {
                kb_layout = "${opts.kbdLayout}";
                kb_variant = "${opts.kbdVariant or ""}";

                repeat_delay = 300; # or 212
                repeat_rate = 30;

                follow_mouse = 1;

                touchpad.natural_scroll = false;

                tablet.output = "current";

                sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                force_no_accel = true;
              };

              general = {
                gaps_in = 4;
                gaps_out = 9;
                border_size = 2;
                resize_on_border = true;
                layout = "dwindle"; # dwindle or master
                # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
              }
              // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              };

              decoration = {
                shadow.enabled = false;
                rounding = 10;
                dim_special = 0.3;
                blur = {
                  enabled = true;
                  special = true;
                  size = 6; # 6
                  passes = 2; # 3
                  new_optimizations = true;
                  ignore_opacity = true;
                  xray = false;
                };
              };

              group = {
              }
              // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              };

              layerrule = [
                "blur, rofi"
                "ignorezero, rofi"
                "ignorealpha 0.7, rofi"

                "blur, swaync-control-center"
                "blur, swaync-notification-window"
                "ignorezero, swaync-control-center"
                "ignorezero, swaync-notification-window"
                "ignorealpha 0.7, swaync-control-center"
                # "ignorealpha 0.8, swaync-notification-window"
                # "dimaround, swaync-control-center"
              ];

              animations = {
                enabled = true;
                bezier = [
                  "linear, 0, 0, 1, 1"
                  "md3_standard, 0.2, 0, 0, 1"
                  "md3_decel, 0.05, 0.7, 0.1, 1"
                  "md3_accel, 0.3, 0, 0.8, 0.15"
                  "overshot, 0.05, 0.9, 0.1, 1.1"
                  "crazyshot, 0.1, 1.5, 0.76, 0.92"
                  "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                  "fluent_decel, 0.1, 1, 0, 1"
                  "easeInOutCirc, 0.85, 0, 0.15, 1"
                  "easeOutCirc, 0, 0.55, 0.45, 1"
                  "easeOutExpo, 0.16, 1, 0.3, 1"
                ];
                animation = [
                  "windows, 1, 3, md3_decel, popin 60%"
                  "border, 1, 10, default"
                  "fade, 1, 2.5, md3_decel"
                  # "workspaces, 1, 3.5, md3_decel, slide"
                  "workspaces, 1, 3.5, easeOutExpo, slide"
                  # "workspaces, 1, 7, fluent_decel, slidefade 15%"
                  # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
                  "specialWorkspace, 1, 3, md3_decel, slidevert"
                ];
              };

              render = {
                direct_scanout = 2; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
              };

              cursor = {
                inactive_timeout = 5;
              };

              gestures = {
                gesture = [
                  "3, horizontal, workspace"
                  "3, up, fullscreen"
                  "3, down, close"
                ];
              };

              dwindle = {
                pseudotile = true;
                preserve_split = true;
              };

              master = {
                new_status = "master";
                new_on_top = true;
                mfact = 0.5;
              };

              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };

              misc = {
                disable_hyprland_logo = true;
                mouse_move_focuses_monitor = true;
                swallow_regex = "^(kitty|foot|footclient)$";
                enable_swallow = true;
                vfr = true; # always keep on
                vrr = 1; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only)
              };

              xwayland.force_zero_scaling = true;

              windowrule = [
                # Can use FLOAT FLOAT for active and inactive or just FLOAT
                "opacity 0.80 0.80,class:^(kitty|foot|footclient)$"
                "opacity 0.90 0.90,class:^(gcr-prompter)$" # keyring prompt
                "opacity 0.90 0.90,title:^(Hyprland Polkit Agent)$" # polkit prompt
                "opacity 1.00 1.00,class:^(firefox)$"
                "opacity 1.00 1.00,class:^(org\.qutebrowser\.qutebrowser)$"
                "opacity 0.80 0.80,class:^(Steam)$"
                "opacity 0.80 0.80,class:^(steam)$"
                "opacity 0.80 0.80,class:^(steamwebhelper)$"
                "opacity 0.80 0.80,class:^(Spotify)$"
                "opacity 0.80 0.80,title:(.*)(Spotify)(.*)$"
                "opacity 0.80 0.80,class:^(editor)$"
                "opacity 0.80 0.80,class:^(VSCodium)$"
                "opacity 0.80 0.80,class:^(codium-url-handler)$"
                "opacity 0.80 0.80,class:^(code)$"
                "opacity 0.80 0.80,class:^(code-url-handler)$"
                "opacity 0.80 0.80,class:^(terminalFileManager)$"
                "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
                "opacity 0.80 0.80,class:^(org.kde.ark)$"
                "opacity 0.80 0.80,class:^(nwg-look)$"
                "opacity 0.80 0.80,class:^(qt5ct)$"
                "opacity 0.80 0.80,class:^(qt6ct)$"
                "opacity 0.80 0.80,class:^(yad)$"

                "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
                "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$" # Cartridges-Gtk
                "opacity 0.80 0.80,class:^(com.obsproject.Studio)$" # Obs-Qt
                "opacity 0.80 0.80,class:^(gnome-boxes)$" # Boxes-Gtk
                "opacity 0.90 0.90,class:^(discord)$" # Discord-Electron
                "opacity 0.90 0.90,class:^(WebCord)$" # WebCord-Electron
                "opacity 0.80 0.80,class:^(app.drey.Warp)$" # Warp-Gtk
                "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "opacity 0.80 0.80,class:^(Signal)$" # Signal-Gtk
                "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk

                "opacity 0.80 0.70,class:^(pavucontrol)$"
                "opacity 0.80 0.70,class:^(org.pulseaudio.pavucontrol)$"
                "opacity 0.80 0.70,class:^(blueman-manager)$"
                "opacity 0.80 0.70,class:^(.blueman-manager-wrapped)$"
                "opacity 0.80 0.70,class:^(nm-applet)$"
                "opacity 0.80 0.70,class:^(nm-connection-editor)$"
                "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

                "content game, tag:games"
                "tag +games, content:game"
                "tag +games, class:^(steam_app.*|steam_app_d+)$"
                "tag +games, class:^(gamescope)$"
                "tag +games, class:(Waydroid)"
                "tag +games, class:(osu!)"

                # Games
                "syncfullscreen,tag:games"
                "fullscreen,tag:games"
                "noborder 1,tag:games"
                "noshadow,tag:games"
                "noblur,tag:games"
                "noanim,tag:games"

                # Float and pin Picture-in-Picture in browsers
                "float,title:^(Picture-in-Picture)$,class:^(zen|zen-beta|floorp|firefox)$"
                "pin,title:^(Picture-in-Picture)$,class:^(zen|zen-beta|floorp|firefox)$"

                "float,class:^(qt5ct)$"
                "float,class:^(nwg-look)$"
                "float,class:^(org.kde.ark)$"
                "float,class:^(Signal)$" # Signal-Gtk
                "float,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "float,class:^(app.drey.Warp)$" # Warp-Gtk
                "float,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "float,class:^(eog)$" # Imageviewer-Gtk
                "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
                "float,class:^(yad)$"
                "float,class:^(pavucontrol)$"
                "float,class:^(blueman-manager)$"
                "float,class:^(.blueman-manager-wrapped)$"
                "float,class:^(nm-applet)$"
                "float,class:^(nm-connection-editor)$"
                "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
              ];
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
                ",XF86MonBrightnessDown,exec,brightnessctl set 2%-"
                ",XF86MonBrightnessUp,exec,brightnessctl set +2%"
                ",XF86AudioLowerVolume,exec,pamixer -d 2"
                ",XF86AudioRaiseVolume,exec,pamixer -i 2"
              ];
              bind =
                let
                  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
                in
                [
                  # Keybinds help menu
                  "$mainMod SHIFT, slash, exec, hypr-keybinds"

                  # Window/Session actions
                  "$mainMod, Tab, hyprexpo:expo, toggle" # toggle overview
                  "$mainMod, W, togglefloating" # toggle the window on focus to float
                  "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to group
                  "ALT, return, fullscreen" # toggle the window on focus to fullscreen
                  "$mainMod, Q, killactive" # killactive, kill the window on focus
                  "ALT, F4, killactive" # killactive, kill the window on focus
                  "$mainMod, delete, exit" # kill hyperland session
                  "$mainMod ALT, L, exec, hyprlock" # lock screen
                  "$mainMod, backspace, exec, pkill -x wlogout || wlogout -b 4" # logout menu
                  "$CONTROL, ESCAPE, exec, pkill waybar || waybar" # toggle waybar

                  # Applications/Programs
                  "$mainMod, Return, exec, $terminal"
                  "$mainMod, T, exec, $terminal"
                  "$mainMod, F, exec, $fileManager"
                  "$mainMod, E, exec, $editor"
                  "$mainMod, B, exec, $browser"
                  "$CONTROL ALT, DELETE, exec, $terminal -e ${getExe pkgs.btop}" # System Monitor
                  "$mainMod CTRL, C, exec, hyprpicker --autocopy --format=hex" # Colour Picker

                  "$mainMod, A, exec, launcher drun" # launch desktop applications
                  "$mainMod, SPACE, exec, launcher drun" # launch desktop applications
                  "$mainMod SHIFT, W, exec, launcher wallpaper" # launch wallpaper switcher
                  # "$mainMod, Z, exec, launcher emoji" # launch emoji picker
                  # "$mainMod, tab, exec, launcher window" # switch between desktop applications
                  # "$mainMod, R, exec, launcher file" # brrwse system files
                  "$mainMod ALT, K, exec, ${./scripts/keyboard-switch.sh}" # change keyboard layout
                  "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
                  "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # swayNC panel
                  "$mainMod, V, exec, ${./scripts/clip-manager.sh}" # Clipboard Manager
                  "$mainMod CTRL, W, exec, random-wall" # random wallpaper

                  "$mainMod, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"
                  # "$mainMod ALT, mouse:276, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 60"
                  "$mainMod, F9, exec, hyprsunset --temperature 3500" # good values: 3500, 3000, 2500
                  "$mainMod, F10, exec, pkill hyprsunset"

                  # Screenshot/Screencapture
                  "$mainMod, P, exec, ${./scripts/screenshot.sh} s" # drag to snip an area / click on a window to print it
                  "$mainMod CTRL, P, exec, ${./scripts/screenshot.sh} sf" # frozen screen, drag to snip an area / click on a window to print it
                  "$mainMod, print, exec, ${./scripts/screenshot.sh} m" # print focused monitor
                  "$mainMod ALT, P, exec, ${./scripts/screenshot.sh} p" # print all monitor outputs

                  # Functional keybinds
                  ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
                  ",XF86AudioMicMute,exec,pamixer --default-source -t" # mute mic
                  ",XF86AudioMute,exec,pamixer -t" # mute audio
                  ",XF86AudioPlay,exec,playerctl play-pause" # Play/Pause media
                  ",XF86AudioPause,exec,playerctl play-pause" # Play/Pause media
                  ",xf86AudioNext,exec,playerctl next" # go to next media
                  ",xf86AudioPrev,exec,playerctl previous" # go to previous media

                  # ",xf86AudioNext,exec,${./scripts/media-ctrl.sh} next" # go to next media
                  # ",xf86AudioPrev,exec,${./scripts/media-ctrl.sh} previous" # go to previous media
                  # ",XF86AudioPlay,exec,${./scripts/media-ctrl.sh} play-pause" # go to next media
                  # ",XF86AudioPause,exec,${./scripts/media-ctrl.sh} play-pause" # go to next media

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

                  # Special workspaces (scratchpad)
                  "$mainMod CTRL, S, movetoworkspacesilent, special"
                  "$mainMod ALT, S, movetoworkspacesilent, special"
                  "$mainMod, S, togglespecialworkspace,"
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
                ++ lib.optionals (config.programs.tmux.enable or false) [
                  "$mainMod SHIFT, T, exec, launcher tmux" # launch tmux sessions
                ]
                ++ lib.optionals (opts.rbw.rofi-rbw or false) [
                  "$mainMod ALT, U, exec, launcher rbw" # launch password manager
                ]
                ++ lib.optionals (osConfig.programs.steam.enable or false) [
                  "$mainMod, G, exec, launcher games" # game launcher
                  "$mainMod ALT, G, exec, ${./scripts/gamemode.sh}" # disable hypr effects for gamemode
                ];

              bindm = [
                # Move/Resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];

              monitor = opts.hyprland.monitor or [ ];

              plugin = {
                hyprexpo = {
                  columns = 3;
                  gap_size = 5;
                  bg_col = "rgb(111111)";
                  workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

                  enable_gesture = true;
                  gesture_fingers = 3;
                  gesture_distance = 300;
                  gesture_positive = false;
                };
              };
            };
            extraConfig = ''
              monitor=,preferred,auto,1
              binds {
                  workspace_back_and_forth = 0
                  #allow_workspace_cycles = 1
                  #pass_mouse_when_bound = 0
                }
            ''
            + (opts.hyprland.extraConfig);
          };
        }
      )
    ];
}
