{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "lock";
            command = "${pkgs.swaylock}/bin/swaylock &";
          }
          {
            event = "unlock";
            command = "${pkgs.procps}/bin/pkill --signal SIGUSR1 swaylock";
          }
          {
            event = "before-sleep";
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            event = "after-resume";
            command = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          }
        ];
        timeouts =
          lib.optionals ((opts.swayidle.time.lock or "") != "") [
            {
              timeout = opts.swayidle.time.lock;
              command = "${pkgs.systemd}/bin/loginctl lock-session";
            }
          ]
          ++ lib.optionals ((opts.swayidle.time.dpmsOff or "") != "") [
            {
              timeout = opts.swayidle.time.dpmsOff;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
              resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
            }
          ]
          ++ lib.optionals ((opts.swayidle.time.sleep or "") != "") [
            (
              if opts.hibernate then
                {
                  timeout = opts.swayidle.time.sleep;
                  command = "${pkgs.systemd}/bin/systemctl hibernate";
                }
              else
                {
                  timeout = opts.swayidle.time.sleep;
                  command = "${pkgs.systemd}/bin/systemctl suspend";
                }
            )
          ];
      };
    })
  ];
}
