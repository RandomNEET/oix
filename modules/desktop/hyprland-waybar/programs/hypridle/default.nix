{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock";
            unlock_cmd = "pkill --signal SIGUSR1 hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener =
            lib.optionals ((opts.hypridle.time.lock or "600") != "") [
              {
                timeout = opts.hypridle.time.lock;
                on-timeout = "loginctl lock-session";
              }
            ]
            ++ lib.optionals ((opts.hypridle.time.dpmsOff or "1800") != "") [
              {
                timeout = opts.hypridle.time.dpmsOff;
                on-timeout = "hyprctl dispatch dpms off";
                on-resume = "hyprctl dispatch dpms on";
              }
            ]
            ++ lib.optionals ((opts.hypridle.time.sleep or "3600") != "") [
              (
                if opts.hibernate then
                  {
                    timeout = opts.hypridle.time.sleep;
                    on-timeout = "systemctl hibernate";
                  }
                else
                  {
                    timeout = opts.hypridle.time.sleep;
                    on-timeout = "systemctl suspend";
                  }
              )
            ];
        };
      };
    }
  ];
}
