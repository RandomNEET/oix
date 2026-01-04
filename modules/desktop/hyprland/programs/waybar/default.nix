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
    (_: {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = false;
          target = "graphical-session.target";
        };
        settings = [
          {
            layer = "top";
            position = "top";
            height = 32;
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = true;
            ipc = true;
            fixed-center = true;
            margin-top = 10;
            margin-left = 10;
            margin-right = 10;
            margin-bottom = 0;

            modules-left = [
              "hyprland/workspaces"
              "hyprland/window"
              "cava"
            ];
            modules-center = [
              "idle_inhibitor"
              "clock"
            ];
            modules-right = [
              "cpu"
              "memory"
            ]
            ++ lib.optionals (lib.match ".*integrated.*" (opts.gpu or "") == null) [
              "custom/gpuinfo"
            ]
            ++ [
              "backlight"
              "pulseaudio"
              "bluetooth"
              "network"
              "battery"
              "tray"
              "custom/notification"
              "custom/power"
            ];

            "hyprland/window" = {
              format = "{title}";
              icon = true;
              icon-size = 20;
              separate-outputs = true;
              max-length = 30;
            };

            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              active-only = false;
              on-click = "activate";
            };

            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
              on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
              on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
            };

            "battery" = {
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };

            "bluetooth" = {
              format = "";
              format-connected = " {num_connections}";
              tooltip-format = " {device_alias}";
              tooltip-format-connected = "{device_enumerate}";
              tooltip-format-enumerate-connected = " {device_alias}";
              on-click = "blueman-manager";
            };

            "cava" = {
              hide_on_silence = true;
              framerate = 60;
              bars = 10;
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
              input_delay = 1;
              sleep_timer = 5;
              bar_delimiter = 0;
              on-click = "playerctl play-pause";
            };

            "clock" = {
              format = "{:%a %d %b %R}";
              format-alt = "{:%I:%M:%p}";
              tooltip-format = "<tt>{calendar}</tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='#ffead3'><b>{}</b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  today = "<span color='#ff6699'><b>{}</b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };

            "cpu" = {
              interval = 10;
              format = "󰍛 {usage}%";
              format-alt = "{icon0}{icon1}{icon2}{icon3}";
              format-icons = [
                "▁"
                "▂"
                "▃"
                "▄"
                "▅"
                "▆"
                "▇"
                "█"
              ];
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "󰥔";
                deactivated = "";
              };
            };

            "memory" = {
              interval = 30;
              format = "󰾆 {percentage}%";
              format-alt = "󰾅 {used}GB";
              max-length = 10;
              tooltip = true;
              tooltip-format = " {used:.1f}GB/{total:.1f}GB";
            };

            "mpris" = {
              format = "{status_icon} {dynamic}";
              status-icons = {
                playing = "";
                paused = "";
                stopped = "";
              };
              dynamic-len = 30;
              dynamic-order = [
                "title"
                "artist"
                "album"
              ];
            };

            "network" = {
              format-wifi = "󰤨 ";
              format-ethernet = "󱘖 ";
              format-disconnected = "󰤮 ";
              format-alt = "󰤨 {signalStrength}%";
              tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
            };

            "pulseaudio" = {
              format = "{icon} {volume}";
              format-muted = " ";
              on-click = "pavucontrol -t 3";
              tooltip-format = "{icon} {desc} // {volume}%";
              scroll-step = 4;
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [
                  ""
                  ""
                  ""
                ];
              };
            };

            "pulseaudio#microphone" = {
              format = "{format_source}";
              format-source = " {volume}%";
              format-source-muted = "";
              on-click = "pavucontrol -t 4";
              tooltip-format = "{format_source} {source_desc} // {source_volume}%";
              scroll-step = 5;
            };

            "temperature" = {
              hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
              critical-threshold = 85;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                ""
                ""
                ""
              ];
              interval = 10;
            };

            "tray" = {
              icon-size = 14;
              spacing = 6;
            };

            "custom/gpuinfo" = {
              exec = "${../../scripts/gpuinfo.sh}";
              return-type = "json";
              format = "{0}";
              on-click = "${../../scripts/gpuinfo.sh} --toggle";
              interval = 5;
              tooltip = true;
              max-length = 1000;
            };

            "custom/notification" = {
              tooltip = false;
              format = "{icon}";
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
                inhibited-notification = "<span foreground='red'><sup></sup></span>";
                inhibited-none = "";
                dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
                dnd-inhibited-none = "";
              };
              return-type = "json";
              exec-if = "which swaync-client";
              exec = "swaync-client -swb";
              on-click = "swaync-client -t -sw";
              on-click-right = "swaync-client -d -sw";
              escape = true;
            };

            "custom/power" = {
              format = "{}";
              on-click = "wlogout -b 4";
              interval = 86400;
              tooltip = true;
            };
          }
        ];
        style = ''
          * {
            font-family: ${config.stylix.fonts.monospace.name}; 
            font-size: 14px;
            font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
            margin: 0px;
            padding: 0px;
          }

          window#waybar {
            transition-property: background-color;
            transition-duration: 0.5s;
            background:  transparent;
            border-radius: 10px;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          tooltip {
            background: #${colors.base00};
            border-radius: 8px;
          }

          tooltip label {
            color: #${colors.base05};
            margin-right: 5px;
            margin-left: 5px;
          }

          .modules-left {
            background: #${colors.base00};
            border:  1px solid #${colors.base0D};
            padding-right: 15px;
            padding-left: 2px;
            border-radius: 10px;
          }

          .modules-center {
            background: #${colors.base00};
            border: 0.5px solid #${colors.base03};
            padding-right:  5px;
            padding-left: 5px;
            border-radius: 10px;
          }

          .modules-right {
            background: #${colors.base00};
            border: 1px solid #${colors.base0D};
            padding-right: 15px;
            padding-left: 15px;
            border-radius: 10px;
          }

          #backlight,
          #backlight-slider,
          #battery,
          #bluetooth,
          #cava,
          #clock,
          #cpu,
          #disk,
          #idle_inhibitor,
          #keyboard-state,
          #memory,
          #mode,
          #mpris,
          #network,
          #pulseaudio,
          #pulseaudio-slider,
          #taskbar button,
          #taskbar,
          #temperature,
          #tray,
          #window,
          #wireplumber,
          #workspaces,
          #custom-gpuinfo,
          #custom-notification,
          #custom-power {
            padding-top: 3px;
            padding-bottom: 3px;
            padding-right: 6px;
            padding-left: 6px;
          }

          @keyframes blink {
            to {
              color: #${colors.base02};
            }
          }

          #window {
            color: #${colors.base05};
          }

          #pulseaudio.muted,
          #temperature.critical {
            background-color: #${colors.base08};
          }

          #clock,
          #cpu {
            color: #${colors.base0A};
          }

          #battery,
          #memory {
            color: #${colors.base0B};
          }

          #disk,
          #temperature {
            color: #${colors.base0C};
          }

          #backlight,
          #bluetooth,
          #idle_inhibitor,
          #language,
          #network,
          #pulseaudio {
            color: #${colors.base0D};
          }

          #cava,
          #mpris,
          #pulseaudio.bluetooth {
            color: #${colors.base0E};
          }

          #keyboard-state {
            color:  #${colors.base0F};
          }

          #workspaces button {
            box-shadow: none;
            text-shadow: none;
            padding: 0px;
            border-radius: 9px;
            background-color: #${colors.base01};
            padding-left: 4px;
            padding-right: 4px;
            animation:  gradient_f 20s ease-in infinite;
            transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.682);
          }

          #workspaces button:hover {
            border-radius: 10px;
            color: #${colors.base03};
            background-color: #${colors.base02};
            padding-left: 2px;
            padding-right: 2px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
          }

          #workspaces button.active {
            color: #${colors.base09};
            border-radius: 10px;
            padding-left: 8px;
            padding-right: 8px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
          }

          #workspaces button.urgent {
            color: #${colors.base08};
            border-radius:  0px;
          }

          #battery.critical:not(.charging) {
            background-color: #${colors.base08};
            color: #${colors.base05};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
            box-shadow: inset 0 -3px transparent;
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
          }


          #taskbar button.active {
            padding-left: 8px;
            padding-right: 8px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
          }

          #taskbar button:hover {
            padding-left: 2px;
            padding-right: 2px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
          }

          #network.disconnected,
          #network.disabled {
            background-color: #${colors.base02};
            color: #${colors.base05};
          }

          #pulseaudio-slider slider {
            min-width: 0px;
            min-height: 0px;
            opacity: 0;
            background-image: none;
            border: none;
            box-shadow: none;
          }

          #pulseaudio-slider trough {
            min-width: 80px;
            min-height: 5px;
            border-radius: 5px;
          }

          #pulseaudio-slider highlight {
            min-height: 10px;
            border-radius: 5px;
          }

          #backlight-slider slider {
            min-width: 0px;
            min-height: 0px;
            opacity:  0;
            background-image: none;
            border: none;
            box-shadow: none;
          }

          #backlight-slider trough {
            min-width: 80px;
            min-height: 10px;
            border-radius: 5px;
          }

          #backlight-slider highlight {
            min-width: 10px;
            border-radius: 5px;
          }

          #custom-notification {
            color: #${colors.base06};
            padding: 0px 5px;
            border-radius: 5px;
          }
        '';
      };
      home.packages = with pkgs; [ cava ];
    })
  ];
}
