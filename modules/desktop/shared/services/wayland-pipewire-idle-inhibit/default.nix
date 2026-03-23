{ pkgs, ... }:
{
  systemd.user = {
    services.wayland-pipewire-idle-inhibit = {
      description = "Inhibit Wayland idling when media is played through pipewire";
      after = [
        "pipewire.service"
        "graphical-session.target"
      ];
      wants = [ "pipewire.service" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.wayland-pipewire-idle-inhibit}/bin/wayland-pipewire-idle-inhibit -d 5";
        Restart = "always";
        RestartSec = 10;
      };
    };
  };
}
