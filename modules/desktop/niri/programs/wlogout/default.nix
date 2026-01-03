{ config, opts, ... }:
let
  colors = config.lib.stylix.colors;
in
{
  home-manager.sharedModules = [
    (_: {
      xdg.configFile."wlogout/icons".source = ./icons;
      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "logout";
            action = "niri msg action quit -s";
            text = "Exit";
            keybind = "e";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
          (
            if opts.hibernate then
              {
                label = "hibernate";
                action = "systemctl hibernate";
                text = "Hibernate";
                keybind = "u";
              }
            else
              {
                label = "suspend";
                action = "systemctl suspend";
                text = "Suspend";
                keybind = "u";
              }
          )
        ];
        style = ''
          window {
            font-family: monospace;
            font-size: 14pt;
            color: #${colors.base05}; 
            background-color: rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 0.5);
          }

          button {
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            border: none;
            background-color: transparent;
            margin: 5px;
            transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
          }

          button:hover {
            background-color: rgba(${colors.base02-rgb-r}, ${colors.base02-rgb-g}, ${colors.base02-rgb-b}, 0.2);
          }

          button:focus {
            background-color: #${colors.base0E};
            color: #${colors.base00};
          }

          #lock { background-image: image(url("icons/lock.png")); }
          #lock:focus { background-image: image(url("icons/lock-hover.png")); }

          #logout { background-image: image(url("icons/logout.png")); }
          #logout:focus { background-image: image(url("icons/logout-hover.png")); }

          #shutdown { background-image: image(url("icons/power.png")); }
          #shutdown:focus { background-image: image(url("icons/power-hover.png")); }

          #reboot { background-image: image(url("icons/restart.png")); }
          #reboot:focus { background-image: image(url("icons/restart-hover.png")); }

          #hibernate { background-image: image(url("icons/sleep.png")); }
          #hibernate:focus { background-image: image(url("icons/sleep-hover.png")); }

          #suspend { background-image: image(url("icons/sleep.png")); }
          #suspend:focus { background-image: image(url("icons/sleep-hover.png")); }
        '';
      };
    })
  ];
}
