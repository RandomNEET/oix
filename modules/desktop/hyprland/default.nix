{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
{
  imports = [
    ./programs/fcitx5
    ./programs/gowall
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
    script = "${import ./scripts/random-wall.nix {
      inherit
        config
        lib
        pkgs
        opts
        ;
    }}";
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
            wl-clipboard
            wlrctl
            wtype
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
            plugins = with pkgs; [
              # hyprlandPlugins.hyprspace
            ];
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
                  "${./scripts/randomwallctl.sh} -r"
                ]
                ++ lib.optional osConfig.services.power-profiles-daemon.enable "${
                  import ./scripts/powermodectl.nix { inherit osConfig pkgs; }
                } -r"
                ++ lib.optional (
                  (opts.terminal == "foot") && (opts.foot.server or false)
                ) "${getExe pkgs.foot} --server"
              );

              input = {
                kb_layout = "${opts.kbdLayout}";
                kb_variant = "${opts.kbdVariant or ""}";

                repeat_delay = 300;
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
                layout = "dwindle";
              };

              decoration = {
                shadow.enabled = false;
                rounding = 10;
                dim_special = 0.3;
                blur = {
                  enabled = true;
                  size = 6;
                  passes = 2;
                  ignore_opacity = true;
                  new_optimizations = true;
                  xray = false;
                  special = false;
                };
              };

              group = {
                groupbar = {
                  font_size = 16;
                  height = 30;
                };
              };

              layerrule = [
                "blur on, match:namespace rofi"
                "ignore_alpha 0.7, match:namespace rofi"

                "blur on, match:namespace swaync-control-center"
                "blur on, match:namespace swaync-notification-window"
                "ignore_alpha 0.7, match:namespace swaync-control-center"
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
                  "workspaces, 1, 3.5, easeOutExpo, slide"
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
                "opacity 0.80 0.80, match:class ^(kitty|foot|footclient)$"
                "opacity 0.90 0.90, match:class ^(gcr-prompter)$" # keyring prompt
                "opacity 0.90 0.90, match:title ^(Hyprland Polkit Agent)$" # polkit prompt
                "opacity 1.00 1.00, match:class ^(firefox)$"
                "opacity 1.00 1.00, match:class ^(org\.qutebrowser\.qutebrowser)$"
                "opacity 0.80 0.80, match:class ^(Steam)$"
                "opacity 0.80 0.80, match:class ^(steam)$"
                "opacity 0.80 0.80, match:class ^(steamwebhelper)$"
                "opacity 0.80 0.80, match:class ^(Spotify)$"
                "opacity 0.80 0.80, match:title (.*)(Spotify)(.*)$"
                "opacity 0.80 0.80, match:class ^(editor)$"
                "opacity 0.80 0.80, match:class ^(VSCodium)$"
                "opacity 0.80 0.80, match:class ^(codium-url-handler)$"
                "opacity 0.80 0.80, match:class ^(code)$"
                "opacity 0.80 0.80, match:class ^(code-url-handler)$"
                "opacity 0.80 0.80, match:class ^(terminalFileManager)$"
                "opacity 0.80 0.80, match:class ^(org.kde.dolphin)$"
                "opacity 0.80 0.80, match:class ^(org.kde.ark)$"
                "opacity 0.80 0.80, match:class ^(nwg-look)$"
                "opacity 0.80 0.80, match:class ^(qt5ct)$"
                "opacity 0.80 0.80, match:class ^(qt6ct)$"
                "opacity 0.80 0.80, match:class ^(yad)$"

                "opacity 0.90 0.90, match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "opacity 0.80 0.80, match:class ^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
                "opacity 0.80 0.80, match:class ^(hu.kramo.Cartridges)$" # Cartridges-Gtk
                "opacity 0.80 0.80, match:class ^(com.obsproject.Studio)$" # Obs-Qt
                "opacity 0.80 0.80, match:class ^(gnome-boxes)$" # Boxes-Gtk
                "opacity 0.90 0.90, match:class ^(discord)$" # Discord-Electron
                "opacity 0.90 0.90, match:class ^(WebCord)$" # WebCord-Electron
                "opacity 0.80 0.80, match:class ^(app.drey.Warp)$" # Warp-Gtk
                "opacity 0.80 0.80, match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "opacity 0.80 0.80, match:class ^(Signal)$" # Signal-Gtk
                "opacity 0.80 0.80, match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk

                "opacity 0.80 0.70, match:class ^(pavucontrol)$"
                "opacity 0.80 0.70, match:class ^(org.pulseaudio.pavucontrol)$"
                "opacity 0.80 0.70, match:class ^(blueman-manager)$"
                "opacity 0.80 0.70, match:class ^(.blueman-manager-wrapped)$"
                "opacity 0.80 0.70, match:class ^(nm-applet)$"
                "opacity 0.80 0.70, match:class ^(nm-connection-editor)$"
                "opacity 0.80 0.70, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"

                "content game, match:tag games"
                "tag +games, match:content game"
                "tag +games, match:class ^(steam_app.*|steam_app_d+)$"
                "tag +games, match:class ^(gamescope)$"
                "tag +games, match:class (Waydroid)"
                "tag +games, match:class (osu!)"

                # Games
                "sync_fullscreen on, match:tag games"
                "fullscreen on, match:tag games"
                "border_size 0, match:tag games"
                "no_shadow on, match:tag games"
                "no_blur on, match:tag games"
                "no_anim on, match:tag games"

                # Float and pin Picture-in-Picture in browsers
                "match:float true, match:title ^(Picture-in-Picture)$, match:class ^(zen|zen-beta|floorp|firefox)$"
                "match:pin true, match:title ^(Picture-in-Picture)$, match:class ^(zen|zen-beta|floorp|firefox)$"

                "match:float true, match:class ^(qt5ct)$"
                "match:float true, match:class ^(nwg-look)$"
                "match:float true, match:class ^(org.kde.ark)$"
                "match:float true, match:class ^(Signal)$" # Signal-Gtk
                "match:float true, match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "match:float true, match:class ^(app.drey.Warp)$" # Warp-Gtk
                "match:float true, match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "match:float true, match:class ^(eog)$" # Imageviewer-Gtk
                "match:float true, match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
                "match:float true, match:class ^(yad)$"
                "match:float true, match:class ^(pavucontrol)$"
                "match:float true, match:class ^(blueman-manager)$"
                "match:float true, match:class ^(.blueman-manager-wrapped)$"
                "match:float true, match:class ^(nm-applet)$"
                "match:float true, match:class ^(nm-connection-editor)$"
                "match:float true, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
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
                  "$mainMod SHIFT, slash, exec, ${
                    import ./scripts/keybinds.nix {
                      inherit
                        osConfig
                        config
                        lib
                        pkgs
                        opts
                        ;
                    }
                  }"

                  # Window/Session actions
                  # "$mainMod, Tab, overview:toggle" # toggle overview
                  "$mainMod, W, togglefloating" # toggle the window on focus to float
                  "$mainMod, G, togglegroup" # toggle the window on focus to group
                  "ALT, return, fullscreen" # toggle the window on focus to fullscreen
                  "$mainMod, Q, killactive" # killactive, kill the window on focus
                  "$mainMod ALT, L, exec, hyprlock" # lock screen
                  "$mainMod, backspace, exec, pkill -x wlogout || wlogout -b 4" # logout menu
                  "$CONTROL, ESCAPE, exec, pkill waybar || waybar" # toggle waybar

                  # Special workspace (scratchpad)
                  "$mainMod, S, togglespecialworkspace,"
                  "$mainMod CTRL, S, movetoworkspacesilent, special"

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
                  "$mainMod CTRL, W, exec, random-wall" # random wallpaper
                  "$mainMod CTRL, T, exec, launcher theme" # launch theme switcher
                  "$mainMod ALT, S, exec, launcher spec" # launch specialisation  switcher
                  "$mainMod, V, exec, ${
                    import ./scripts/clip-manager.nix {
                      inherit
                        config
                        lib
                        pkgs
                        opts
                        ;
                    }
                  }" # Clipboard Manager
                  "$mainMod SHIFT, N, exec, swaync-client -t -sw" # swayNC panel
                  "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # swayNC panel

                  "$mainMod, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"
                  "$mainMod, F9, exec, hyprsunset --temperature 3500" # good values: 3500, 3000, 2500
                  "$mainMod, F10, exec, pkill hyprsunset"

                  # Screenshot/Screencapture
                  "$mainMod, P, exec, ${./scripts/screenshot.sh} s" # drag to snip an area / click on a window to print it
                  "$mainMod CTRL, P, exec, ${./scripts/screenshot.sh} sf" # frozen screen, drag to snip an area / click on a window to print it
                  "$mainMod ALT, P, exec, ${./scripts/screenshot.sh} p" # print all monitor outputs
                  "$mainMod, print, exec, ${./scripts/screenshot.sh} m" # print focused monitor
                  "$mainMod SHIFT, print, exec, ${./scripts/screenshot.sh} o" # ocr capture

                  # Functional keybinds
                  ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
                  ",XF86AudioMicMute,exec,pamixer --default-source -t" # mute mic
                  ",XF86AudioMute,exec,pamixer -t" # mute audio
                  ",XF86AudioPlay,exec,playerctl play-pause" # Play/Pause media
                  ",XF86AudioPause,exec,playerctl play-pause" # Play/Pause media
                  ",xf86AudioNext,exec,playerctl next" # go to next media
                  ",xf86AudioPrev,exec,playerctl previous" # go to previous media

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
                ++ lib.optionals (config.programs.tmux.enable or false) [
                  "$mainMod SHIFT, T, exec, launcher tmux" # launch tmux sessions
                ]
                ++ lib.optionals (opts.rbw.rofi-rbw or false) [
                  "$mainMod ALT, U, exec, launcher rbw" # launch password manager
                ]
                ++ lib.optionals (osConfig.programs.steam.enable or false) [
                  "$mainMod SHIFT, G, exec, launcher game" # game launcher
                  "$mainMod CTRL, G, exec, ${./scripts/gamemode.sh}" # disable hypr effects for gamemode
                ];

              bindm = [
                # Move/Resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];

              monitor = opts.hyprland.monitor or [ ];

              plugin = {
                # overview = {
                #   disableBlur = true;
                #   onBottom = true;
                #   centerAligned = true;
                # };
              };
            };

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
