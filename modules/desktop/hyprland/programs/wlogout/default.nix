{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      xdg.configFile."wlogout/icons".source = ./icons;
      programs.wlogout = {
        enable = true;
        layout = [
          {
            label = "logout";
            action = "hyprctl dispatch exit 0";
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
        style = lib.optionalString ((opts.theme or "") != "") (builtins.readFile ./${opts.theme}.css);
      };
    })
  ];
}
