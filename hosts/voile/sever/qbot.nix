{
  systemd.services.qbot = {
    description = "QQ Bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "howl";
      WorkingDirectory = "/home/howl/repo/qbot";
      ExecStart = "/etc/profiles/per-user/howl/bin/direnv exec /home/howl/repo/qbot python /home/howl/repo/qbot/qbot-listen.py";
      Environment = "PYTHONUNBUFFERED=1";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  pixiv-download = {
    description = "Pixiv UID Daily Download";
    serviceConfig = {
      Type = "oneshot";
      User = "howl";
      WorkingDirectory = "/home/howl/repo/qbot";
      ExecStart = "/etc/profiles/per-user/howl/bin/direnv exec /home/howl/repo/qbot python pixiv-uid-daily-download.py";
    };
  };
  pixiv-send = {
    description = "Pixiv UID Daily Send";
    serviceConfig = {
      Type = "oneshot";
      User = "howl";
      WorkingDirectory = "/home/howl/repo/qbot";
      ExecStart = "/etc/profiles/per-user/howl/bin/direnv exec /home/howl/repo/qbot python pixiv-uid-daily-send.py";
    };
  };
  timers = {
    pixiv-download = {
      description = "Timer for Pixiv UID Daily Download";
      timerConfig = {
        OnCalendar = [
          "00..22:00:00"
          "23:00/10:00"
        ];
        Unit = "pixiv-download.service";
      };
      wantedBy = [ "timers.target" ];
    };
    pixiv-send = {
      description = "Timer for Pixiv UID Daily Send";
      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Unit = "pixiv-send.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
