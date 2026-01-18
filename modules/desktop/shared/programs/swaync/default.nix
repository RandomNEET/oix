{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) optionals;
  desktop = opts.desktop;
  stateDir =
    if (lib.strings.hasInfix "hyprland" desktop) then
      "hyprland"
    else if (lib.strings.hasInfix "niri" desktop) then
      "niri"
    else
      "";
in
{
  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        randomwallctl = import ../../scripts/randomwallctl.nix { inherit lib pkgs opts; };
        tlpctl = import ./scripts/tlpctl.nix { inherit osConfig pkgs stateDir; };
      in
      {
        services.swaync = {
          enable = true;
          settings = {
            "$schema" = "/etc/xdg/swaync/configSchema.json";
            positionX = "right";
            positionY = "top";
            cssPriority = "user";
            control-center-margin-top = 22;
            control-center-margin-bottom = 2;
            control-center-margin-right = 1;
            control-center-margin-left = 0;
            notification-icon-size = 64;
            notification-body-image-height = 128;
            notification-body-image-width = 200;
            timeout = 6;
            timeout-low = 3;
            timeout-critical = 0;
            fit-to-screen = false;
            control-center-width = 400;
            control-center-height = 915;
            notification-window-width = 375;
            keyboard-shortcuts = true;
            image-visibility = "when-available";
            transition-time = 200;
            hide-on-clear = false;
            hide-on-action = true;
            script-fail-notify = true;
            widgets = [
              "title"
              "dnd"
              "menubar#desktop"
              "volume"
              "mpris"
              "notifications"
              "buttons-grid"
            ];
            widget-config = {
              title = {
                text = " Quick settings";
                clear-all-button = true;
                button-text = "";
              };
              "menubar#desktop" = {
                "backlight" = {
                  label = "       󰃟  ";
                };
                "menu#screenshot" = {
                  label = "󰄀  Screenshot";
                  position = "left";
                  actions =
                    [ ]
                    ++ optionals (desktop == "hyprland-waybar") [
                      {
                        label = "Whole screen";
                        command = "sh -c 'swaync-client -cp; sleep 1; grimblast copysave output \"/tmp/screenshot.png\"; swappy -f \"/tmp/screenshot.png\"'";
                      }
                      {
                        label = "Whole window / Select region";
                        command = "sh -c 'swaync-client -cp; grimblast copysave area \"/tmp/screenshot.png\"; swappy -f \"/tmp/screenshot.png\"'";
                      }
                    ]
                    ++ optionals (desktop == "niri-waybar") [
                      {
                        label = "Whole screen";
                        command = "niri msg action screenshot-screen";
                      }
                      {
                        label = "Whole window";
                        command = "niri msg action screenshot-window";
                      }
                    ];
                };
                "menu#power" = {
                  label = "  Power Menu";
                  position = "left";
                  actions =
                    [ ]
                    ++ optionals (desktop == "hyprland-waybar") [
                      {
                        label = "  Lock";
                        command = "hyprlock";
                      }
                      {
                        label = "  Logout";
                        command = "hyprctl dispatch exit 0";
                      }
                    ]
                    ++ optionals (desktop == "niri-waybar") [
                      {
                        label = "  Lock";
                        command = "swaylock";
                      }
                      {
                        label = "  Logout";
                        command = "niri msg action quit -s";
                      }
                    ]
                    ++ [
                      {
                        label = "  Shut down";
                        command = "systemctl poweroff";
                      }
                      {
                        label = "  Reboot";
                        command = "systemctl reboot";
                      }
                      (
                        if (opts.hibernate or false) then
                          {
                            label = "󰤄   Hibernate";
                            command = "systemctl hibernate";
                          }
                        else
                          {
                            label = "󰤄   Suspend";
                            command = "systemctl suspend";
                          }
                      )
                    ];
                };
              };
              volume = {
                label = "";
                expand-button-label = "";
                collapse-button-label = "";
                show-per-app = true;
                show-per-app-icon = true;
                show-per-app-label = true;
              };
              dnd = {
                text = " Do Not Disturb";
              };
              mpris = {
                image-size = 96;
                image-radius = 4;
              };
              notifications = {
                text = "Notifications";
                clear-all-button = true;
                button-text = "";
              };
              "buttons-grid" = {
                actions = [
                  {
                    label = "󰝟";
                    type = "toggle";
                    command = "pamixer -t";
                    update-command = "sh -c 'pamixer --get-mute | grep -q true && echo true || echo false'";
                  }
                  {
                    label = "󰍭";
                    type = "toggle";
                    command = "pamixer --default-source -t";
                    update-command = "sh -c 'pamixer --get-mute --default-source | grep true && echo true || echo false'";
                  }
                  {
                    label = "";
                    type = "toggle";
                    command = "blueman-manager";
                    update-command = "sh -c 'bluetoothctl show | grep -q \\\"Powered: yes\\\" && echo true || echo false'";
                  }
                  {
                    label = "󰤨";
                    type = "toggle";
                    command = "sh -c '[ \"$SWAYNC_TOGGLE_STATE\" = true ] && nmcli radio wifi on || nmcli radio wifi off'";
                    update-command = "sh -c 'nmcli radio wifi | grep -q enabled && echo true || echo false'";
                  }
                ]
                ++ lib.optional osConfig.services.tlp.enable {
                  label = "";
                  type = "toggle";
                  command = "${tlpctl} -t";
                  update-command = "${tlpctl} -s && grep -q \"^manual$\" \"$XDG_STATE_HOME/${stateDir}/power-mode\" && echo true || echo false";
                }
                ++ optionals (desktop == "hyprland-waybar") [
                  {
                    label = "󰒲";
                    command = "systemctl --user is-active --quiet hypridle.service && systemctl --user stop hypridle.service || systemctl --user start hypridle.service";
                    type = "toggle";
                    update-command = "pgrep -x hypridle > /dev/null && echo false || echo true";
                  }
                  {
                    label = "󰖚";
                    type = "toggle";
                    command = "pgrep -x hyprsunset >/dev/null && pkill hyprsunset || nohup hyprsunset --temperature 3500";
                    update-command = "pgrep -x hyprsunset >/dev/null && echo true || echo false";
                  }
                  {
                    label = "󰸉";
                    type = "toggle";
                    command = "${randomwallctl} -t";
                    update-command = "${randomwallctl} -s && grep -q \"^enabled$\" \"$XDG_STATE_HOME/${stateDir}/random-wall\" && echo true || echo false";
                  }
                ]
                ++ optionals (desktop == "niri-waybar") [
                  {
                    label = "󰒲";
                    command = "systemctl --user is-active --quiet swayidle.service && systemctl --user stop swayidle.service || systemctl --user start swayidle.service";
                    type = "toggle";
                    update-command = "pgrep -x swayidle > /dev/null && echo false || echo true";
                  }
                  {
                    label = "󰖚";
                    type = "toggle";
                    command = "pgrep -x wlsunset >/dev/null && pkill wlsunset || nohup wlsunset -T 6500";
                    update-command = "pgrep -x wlsunset >/dev/null && echo true || echo false";
                  }
                  {
                    label = "󰸉";
                    type = "toggle";
                    command = "${randomwallctl} -t";
                    update-command = "${randomwallctl} -s && grep -q \"^enabled$\" \"$XDG_STATE_HOME/${stateDir}/random-wall\" && echo true || echo false";
                  }
                ]
                ++ lib.optional osConfig.services.dae.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet dae.service && pkexec systemctl stop dae.service || pkexec systemctl start dae.service";
                  update-command = "pgrep -x dae > /dev/null && echo true || echo false";
                }
                ++ lib.optional osConfig.services.sing-box.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet sing-box.service && pkexec systemctl stop sing-box.service || pkexec systemctl start sing-box.service";
                  update-command = "pgrep -x sing-box > /dev/null && echo true || echo false";
                }
                ++ lib.optional osConfig.services.xray.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet xray.service && pkexec systemctl stop xray.service || pkexec systemctl start xray.service";
                  update-command = "pgrep -x xray > /dev/null && echo true || echo false";
                };
              };
            };
            notification-visibility = {
              mbsync = {
                state = "enabled";
                app-name = "mbsync";
                urgency = "Normal";
              };
              spotify = {
                state = "transient";
                app-name = "Spotify";
                urgency = "Low";
              };
              rmpc = {
                state = "transient";
                app-name = "rmpc";
                urgency = "Low";
              };
              screenshot = {
                state = "transient";
                app-name = "screenshot";
                urgency = "Low";
              };
            };
            scripts = {
              mail-alert = {
                exec = "pw-play /run/current-system/sw/share/sounds/freedesktop/stereo/message.oga";
                run-on = "receive";
                app-name = "mbsync";
              };
            };
          };
        };
        imports = [ ./style.nix ];
      }
    )
  ];
}
