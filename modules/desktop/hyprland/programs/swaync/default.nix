{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
{
  #  use later
  home-manager.sharedModules = [
    (_: {
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
                actions = [
                  {
                    label = "Whole screen";
                    command = "sh -c 'swaync-client -cp; sleep 1; grimblast copysave output \"/tmp/screenshot.png\"; swappy -f \"/tmp/screenshot.png\"'";
                  }
                  {
                    label = "Whole window / Select region";
                    command = "sh -c 'swaync-client -cp; grimblast copysave area \"/tmp/screenshot.png\"; swappy -f \"/tmp/screenshot.png\"'";
                  }
                ];
              };
              "menu#power" = {
                label = "  Power Menu";
                position = "left";
                actions = [
                  {
                    label = "  Lock";
                    command = "hyprlock";
                  }
                  {
                    label = "  Logout";
                    command = "hyprctl dispatch exit 0";
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

                {
                  label = "󰖚";
                  type = "toggle";
                  command = "pgrep -x hyprsunset >/dev/null && pkill hyprsunset || nohup hyprsunset --temperature 3500";
                  update-command = "pgrep -x hyprsunset >/dev/null && echo true || echo false";
                }

                {
                  label = "󰒲";
                  command = "systemctl --user is-active --quiet hypridle.service && systemctl --user stop hypridle.service || systemctl --user start hypridle.service";
                  type = "toggle";
                  update-command = "pgrep -x hypridle > /dev/null && echo false || echo true";
                }

                {
                  label = "󰸉";
                  type = "toggle";
                  command = "${../../scripts/randomwallctl.sh} -t";
                  update-command = "${../../scripts/randomwallctl.sh} -s && grep -q \"^enabled$\" \"$HOME/.config/hypr/random-wall\" && echo true || echo false";
                }
              ]
              ++ lib.optional config.services.power-profiles-daemon.enable {
                label = "";
                type = "toggle";
                command = "powermodectl -t";
                update-command = "powermodectl -s && grep -q \"^performance$\" \"$HOME/.config/hypr/power-mode\" && echo true || echo false";
              }
              ++ lib.optional config.services.tlp.enable {
                label = "";
                type = "toggle";
                command = "powermodectl -t";
                update-command = "powermodectl -s && grep -q \"^manual$\" \"$HOME/.config/hypr/power-mode\" && echo true || echo false";
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
        style = lib.optionalString ((opts.theme or "") != "") (builtins.readFile ./${opts.theme}.css);
      };
    })
  ];
}
