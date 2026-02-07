{ pkgs, opts, ... }:
{
  home-manager.sharedModules = [
    {
      services.swayidle = {
        enable = true;
        events = {
          lock = "${pkgs.swaylock}/bin/swaylock &";
          unlock = "${pkgs.procps}/bin/pkill --signal SIGUSR1 swaylock";
          before-sleep = "${pkgs.systemd}/bin/loginctl lock-session";
          after-resume = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        };
        timeouts = [
          {
            timeout = 600;
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 1800;
            command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          }
          (
            if opts.hibernate then
              {
                timeout = 3600;
                command = "${pkgs.systemd}/bin/systemctl hibernate";
              }
            else
              {
                timeout = 3600;
                command = "${pkgs.systemd}/bin/systemctl suspend";
              }
          )
        ];
      };
    }
  ];
}
