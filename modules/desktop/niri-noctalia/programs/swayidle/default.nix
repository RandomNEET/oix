{ opts, ... }:
{
  home-manager.sharedModules = [
    {
      services.swayidle = {
        enable = true;
        events = {
          lock = "noctalia-shell ipc call lockScreen lock";
          before-sleep = "loginctl lock-session";
          after-resume = "niri msg action power-on-monitors";
        };
        timeouts = [
          {
            timeout = 600;
            command = "loginctl lock-session";
          }
          {
            timeout = 1800;
            command = "niri msg action power-off-monitors";
            resumeCommand = "niri msg action power-on-monitors";
          }
          (
            if (opts.hibernate or false) then
              {
                timeout = 3600;
                command = "systemctl hibernate";
              }
            else
              {
                timeout = 3600;
                command = "systemctl suspend";
              }
          )
        ];
      };
    }
  ];
}
