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
            height = 32; # 35
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
              "niri/workspaces"
              "cava"
            ];
            modules-center = [
              "idle_inhibitor"
              "clock"
            ];
            modules-right =
              lib.optionals (lib.match ".*integrated.*" opts.gpu == null) [
                "custom/gpuinfo"
              ]
              ++ [
                "cpu"
                "memory"
                "backlight"
                "pulseaudio"
                "bluetooth"
                "network"
                "battery"
                "tray"
              ];

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

            "custom/colour-temperature" = {
              format = "{} ";
              exec = "wl-gammarelay-rs watch {t}";
              on-scroll-up = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
              on-scroll-down = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
            };

            "custom/cava_mviz" = {
              exec = "${../../scripts/waybar-cava.sh}";
              format = "{}";
            };

            "cava" = {
              hide_on_silence = false;
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

            "custom/gpuinfo" = {
              exec = "${../../scripts/gpuinfo.sh}";
              return-type = "json";
              format = "{0}";
              on-click = "${../../scripts/gpuinfo.sh} --toggle";
              interval = 5; # once every 5 seconds
              tooltip = true;
              max-length = 1000;
            };

            "mpris" = {
              format = "{player_icon} {title} - {artist}";
              format-paused = "{status_icon} <i>{title} - {artist}</i>";
              player-icons = {
                default = "▶";
                spotify = "";
                mpv = "󰐹";
                vlc = "󰕼";
                firefox = "";
                chromium = "";
                kdeconnect = "";
                mopidy = "";
              };
              status-icons = {
                paused = "⏸";
                playing = "";
              };
              ignored-players = [
                "firefox"
                "chromium"
              ];
              max-length = 30;
            };

            "temperature" = {
              hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
              critical-threshold = 83;
              format = "{icon} {temperatureC}°C";
              format-icons = [
                ""
                ""
                ""
              ];
              interval = 10;
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "󰥔";
                deactivated = "";
              };
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

            "memory" = {
              interval = 30;
              format = "󰾆 {percentage}%";
              format-alt = "󰾅 {used}GB";
              max-length = 10;
              tooltip = true;
              tooltip-format = " {used:.1f}GB/{total:.1f}GB";
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

            "network" = {
              format-wifi = "󰤨 Wi-Fi";
              format-ethernet = "󱘖 Wired";
              format-linked = "󱘖 {ifname} (No IP)";
              format-disconnected = "󰤮 Off";
              format-alt = "󰤨 {signalStrength}%";
              tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
            };

            "bluetooth" = {
              format = "";
              format-connected = " {num_connections}";
              tooltip-format = " {device_alias}";
              tooltip-format-connected = "{device_enumerate}";
              tooltip-format-enumerate-connected = " {device_alias}";
              on-click = "blueman-manager";
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

            "tray" = {
              icon-size = 14;
              spacing = 6;
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

            "custom/power" = {
              format = "{}";
              on-click = "wlogout -b 4";
              interval = 86400; # once every day
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
            background: transparent;
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
            border: 1px solid #${colors.base0D};
            padding-right: 15px;
            padding-left: 2px;
            border-radius: 10px;
          }

          .modules-center {
            background: #${colors.base00};
            border: 0.5px solid #${colors.base03};
            padding-right: 5px;
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
          #custom-backlight,
          #custom-cycle_wall,
          #custom-keybinds,
          #custom-keyboard,
          #custom-light_dark,
          #custom-lock,
          #custom-menu,
          #custom-power_vertical,
          #custom-power,
          #custom-swaync,
          #custom-updater,
          #custom-weather,
          #custom-weather.clearNight,
          #custom-weather.cloudyFoggyDay,
          #custom-weather.cloudyFoggyNight,
          #custom-weather.default,
          #custom-weather.rainyDay,
          #custom-weather.rainyNight,
          #custom-weather.severe,
          #custom-weather.showyIcyDay,
          #custom-weather.snowyIcyNight,
          #custom-weather.sunnyDay {
            padding-top: 3px;
            padding-bottom: 3px;
            padding-right: 6px;
            padding-left: 6px;
          }

          #idle_inhibitor {
            color: #${colors.base0D};
          }

          #bluetooth,
          #backlight {
            color: #${colors.base0D};
          }

          #battery {
            color: #${colors.base0B};
          }

          @keyframes blink {
            to {
              color: #${colors.base02};
            }
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

          #custom-updates {
            color: #${colors.base0D};
          }

          #custom-notification {
            color: #${colors.base06};
            padding: 0px 5px;
            border-radius: 5px;
          }

          #language {
            color: #${colors.base0D};
          }

          #clock {
            color: #${colors.base0A};
          }

          #custom-icon {
            font-size: 15px;
            color: #${colors.base0E};
          }

          #custom-gpuinfo {
            color: #${colors.base08};
          }

          #cpu {
            color: #${colors.base0A};
          }

          #custom-keyboard,
          #memory {
            color: #${colors.base0B};
          }

          #disk {
            color: #${colors.base0C};
          }

          #temperature {
            color: #${colors.base0C};
          }

          #temperature.critical {
            background-color: #${colors.base08};
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
          }

          #keyboard-state {
            color: #${colors.base0F};
          }

          #workspaces button {
            box-shadow: none;
            text-shadow: none;
            padding: 0px;
            border-radius: 9px;
            padding-left: 4px;
            padding-right: 4px;
            animation: gradient_f 20s ease-in infinite;
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

          #workspaces button.persistent {
            color: #${colors.base03};
            border-radius: 10px;
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
            border-radius: 0px;
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

          #custom-cava_mviz {
            color: #${colors.base0E};
          }

          #cava {
            color: #${colors.base0E};
          }

          #mpris {
            color: #${colors.base0E};
          }

          #custom-menu {
            color: #${colors.base0F};
          }

          #custom-power {
            color: #${colors.base08};
          }

          #custom-updater {
            color: #${colors.base08};
          }

          #custom-light_dark {
            color: #${colors.base0D};
          }

          #custom-weather {
            color: #${colors.base0D};
          }

          #custom-lock {
            color: #${colors.base08};
          }

          #pulseaudio {
            color: #${colors.base0D};
          }

          #pulseaudio.bluetooth {
            color: #${colors.base0E};
          }

          #pulseaudio.muted {
            color: #${colors.base08};
          }

          #window {
            color: #${colors.base0E};
          }

          #custom-waybar-mpris {
            color: #${colors.base0D};
          }

          #network {
            color: #${colors.base0D};
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
            opacity: 0;
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
        '';
      };
      home.packages = with pkgs; [ cava ];
    })
  ];
}
