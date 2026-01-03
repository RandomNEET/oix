{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  home-manager.sharedModules = [
    (
      { osConfig, ... }:
      let
        powermodectl = import ../../scripts/powermodectl.nix { inherit osConfig pkgs; };
        randomwallctl = ../../scripts/randomwallctl.sh;
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
            control-center-height = 800;
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
                  actions = [
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
                  actions = [
                    {
                      label = "  Lock";
                      command = "swaylock";
                    }
                    {
                      label = "  Logout";
                      command = "niri msg action quit -s";
                    }
                    {
                      label = "  Shut down";
                      command = "systemctl poweroff";
                    }
                    {
                      label = "  Reboot";
                      command = "systemctl reboot";
                    }
                    (
                      if opts.hibernate or false then
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
                ++ lib.optional config.services.power-profiles-daemon.enable {
                  label = "";
                  type = "toggle";
                  command = "${powermodectl} -t";
                  update-command = "${powermodectl} -s && grep -q \"^performance$\" \"$HOME/.config/niri/power-mode\" && echo true || echo false";
                }
                ++ lib.optional config.services.tlp.enable {
                  label = "";
                  type = "toggle";
                  command = "${powermodectl} -t";
                  update-command = "${powermodectl} -s && grep -q \"^manual$\" \"$HOME/.config/niri/power-mode\" && echo true || echo false";
                }
                ++ [
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
                    update-command = "${randomwallctl} -s && grep -q \"^enabled$\" \"$HOME/.config/niri/random-wall\" && echo true || echo false";
                  }
                ]
                ++ lib.optional config.services.dae.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet dae.service && pkexec systemctl stop dae.service || pkexec systemctl start dae.service";
                  update-command = "pgrep -x dae > /dev/null && echo true || echo false";
                }
                ++ lib.optional config.services.sing-box.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet sing-box.service && pkexec systemctl stop sing-box.service || pkexec systemctl start sing-box.service";
                  update-command = "pgrep -x sing-box > /dev/null && echo true || echo false";
                }
                ++ lib.optional config.services.xray.enable {
                  label = "󰴴";
                  type = "toggle";
                  command = "systemctl is-active --quiet xray.service && pkexec systemctl stop xray.service || pkexec systemctl start xray.service";
                  update-command = "pgrep -x xray > /dev/null && echo true || echo false";
                };
              };
            };
            scripts = {
              example-script = {
                exec = "echo 'Do something...'";
                urgency = "Normal";
              };
            };
            notification-visibility = {
              spotify = {
                state = "enabled";
                urgency = "Low";
                app-name = "Spotify";
              };
            };
          };
          style = ''
            @define-color shadow rgba(0, 0, 0, 0.25);

            * {
              font-family: ${config.stylix.fonts.monospace.name};
              border-radius: 8px;
            }

            .notification {
              background: #${colors.base00};
              border: 1px solid #${colors.base0D};
              border-radius: 8px;
              margin: 6px 0;
            }

            .notification-action {
              border: 2px solid;
              border-top: none;
            }

            .close-button {
              background: transparent;
              color: transparent;
            }

            /*** Notification ***/
            /* Notification header */
            .summary {
              color: #${colors.base05};
              font-size: 16px;
              background: transparent;
              text-shadow: none;
              font-size: 16px;
            }

            .time {
              color: #${colors.base04};
              font-size: 16px;
              background: transparent;
              font-size: 16px;
              text-shadow: none;
              margin-right: 18px;
            }

            .body {
              background: transparent;
              font-size: 15px;
              font-weight: 500;
              color: #${colors.base04};
              text-shadow: none;
            }

            /* The "Notifications" and "Do Not Disturb" text widget */
            .top-action-title {
              color: #${colors.base05};
              text-shadow: none;
            }

            .control-center {
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 8px;
              border: 1px solid #${colors.base0D};
            }

            .control-center .notification-row:focus,
            .control-center .notification-row:hover {
              opacity: 1;
              border-radius: 8px;
            }

            .notification-row {
              outline: none;
              margin: 0;
              padding: 0;
              background: transparent;
              border: none;
            }

            .notification-group {
              background: transparent;
              border: none;
            }

            /*** Widgets ***/

            /* Title widget */
            .widget-title {
              margin: 0px;
              background: transparent;
              border-radius: 4px 4px 0px 0px;
              border-radius: 8px;
              border-bottom: none;
            }

            .widget-title > label {
              margin: 18px 10px;
              font-size: 20px;
              font-weight: 500;
            }

            .widget-title > button {
              font-weight: 700;
              padding: 7px 3px;
              margin-right: 10px;
              background: transparent;
              color: #${colors.base05};
              border: none;
              border-radius: 4px;
            }

            .widget-title > button:hover {
              background: #${colors.base00};
            }

            /* Label widget */
            .widget-label {
              margin: 0px;
              padding: 0px;
              min-height: 5px;
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 0px 0px 4px 4px;
              border-top: none;
            }

            .widget-label > label {
              font-size: 15px;
              font-weight: 400;
            }

            /* Menubar */
            .widget-menubar {
              background: transparent;
              border-radius: 4px;
              border-top: none;
              border-bottom: none;
            }

            .widget-menubar > box > box {
              margin: 5px 5px 5px 5px;
              min-height: 40px;
              border-radius: 4px;
              background: transparent;
            }

            .widget-menubar > box > box > button {
              background: alpha(#${colors.base00}, 0.8);
              min-width: 185px;
              min-height: 50px;
              margin-right: 25px;
              font-size: 14px;
              padding: 5px;
            }

            .widget-menubar > box > box > button:nth-child(2) {
              margin-right: 0px;
              padding-top: 5px;
            }

            .widget-menubar button:hover {
              background: #${colors.base0D};
              box-shadow: none;
            }

            .widget-menubar > box > revealer > box {
              margin: 5px 10px 5px 10px;
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 4px;
            }

            .widget-menubar > box > revealer > box > button {
              background: transparent;
              min-height: 50px;
              padding: 0px;
              margin: 5px;
            }

            /* Buttons grid */
            .widget-buttons-grid {
              background: transparent;
              border-top: none;
              border-bottom: none;
              font-size: 14px;
              font-weight: 500;
              margin: 0px;
              padding: 0px;
              border-radius: 0px;
            }

            .widget-buttons-grid > flowbox > flowboxchild {
              background: #${colors.base00};
              border-radius: 4px;
              min-height: 40px;
              min-width: 85px;
              margin: 5px;
              padding: 0px;
            }

            .widget-buttons-grid > flowbox > flowboxchild > button {
              background: transparent;
              border-radius: 4px;
              margin: 0px;
              border: none;
              box-shadow: none;
            }

            .widget-buttons-grid > flowbox > flowboxchild > button:hover {
              background: #${colors.base0D};
            }

            /* Mpris widget */
            .widget-mpris {
              padding: 8px;
              border-radius: 8px;
              padding-bottom: 15px;
              margin-bottom: 0px;
            }

            .widget-mpris > box > button,
            .widget-mpris-player,
            .widget-mpris-album-art {
              box-shadow: none;
              margin: 10px 0 0 0;
              padding: 5px 10px;
              border-radius: 8px;
            }

            /* Backlight and volume widgets */
            .widget-backlight,
            .widget-volume {
              background: transparent;
              border-top: none;
              border-bottom: none;
              font-size: 13px;
              font-weight: 600;
              border-radius: 0px;
              margin: 0px;
              padding: 0px;
            }

            .widget-volume > box {
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 4px;
              margin: 5px 10px 5px 10px;
              min-height: 50px;
            }

            .widget-volume > box > label {
              min-width: 50px;
              padding: 0px;
            }

            .widget-volume > box > button {
              min-width: 50px;
              box-shadow: none;
              padding: 0px;
            }

            .widget-volume > box > button:hover {
              background: #${colors.base02};
            }

            .widget-volume > revealer > list {
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 4px;
              margin-top: 5px;
              padding: 0px;
            }

            .widget-volume > revealer > list > row {
              padding-left: 10px;
              min-height: 40px;
              background: transparent;
            }

            .widget-volume > revealer > list > row:hover {
              background: transparent;
              box-shadow: none;
              border-radius: 4px;
            }

            .widget-backlight > scale {
              background: alpha(#${colors.base00}, 0.8);
              border-radius: 0px 4px 4px 0px;
              margin: 5px 10px 5px 0px;
              padding: 0px 10px 0px 0px;
              min-height: 50px;
            }

            .widget-backlight > label {
              background: #${colors.base02};
              margin: 5px 0px 5px 10px;
              border-radius: 4px 0px 0px 4px;
              padding: 0px;
              min-height: 50px;
              min-width: 50px;
            }

            /* DND widget */
            .widget-dnd {
              margin: 6px 10px;
              padding: 0 12px;
              font-size: 1.2rem;
            }

            .widget-dnd > switch {
              background: alpha(#${colors.base00}, 0.8);
              font-size: initial;
              border-radius: 8px;
              box-shadow: none;
              padding: 2px;
            }

            .widget-dnd > switch:hover {
              background: alpha(#${colors.base0D}, 0.8);
            }

            .widget-dnd > switch:checked {
              background: #${colors.base05};
            }

            .widget-dnd > switch:checked:hover {
              background: alpha(#${colors.base05}, 0.8);
            }

            .widget-dnd > switch slider {
              background: alpha(#${colors.base0D}, 0.8);
              border-radius: 6px;
            }

            /* Toggles */
            .toggle:checked {
              background: #${colors.base02};
            }

            .toggle:checked:hover {
              background: #${colors.base03};
            }

            scale trough {
              border-radius: 4px;
              background: #${colors.base02};
            }

            scale slider {
              background: #${colors.base05};
            }

            scale slider:hover {
            }

            /* Hide scrollbars */
            scrollbar,
            scrollbar * {
              all: unset;
              min-width: 0px;
              min-height: 0px;
            }

            scrollbar slider {
              background: transparent;
            }

            scrollbar.vertical,
            scrollbar.horizontal {
              background: transparent;
            }
          '';
        };
      }
    )
  ];
}
