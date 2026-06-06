{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.desktop.enable {
    systemd.user = {
      services.wayland-pipewire-idle-inhibit = {
        Unit = {
          Description = "Inhibit Wayland idling when media is played through pipewire";
          Documentation = "https://github.com/rafaelrc7/wayland-pipewire-idle-inhibit";
          After = [
            "pipewire.service"
            "graphical-session.target"
          ];
          Wants = [ "pipewire.service" ];
        };
        Service = {
          ExecStart = "${pkgs.wayland-pipewire-idle-inhibit}/bin/wayland-pipewire-idle-inhibit";
          Restart = "always";
          RestartSec = 10;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
    xdg.configFile."wayland-pipewire-idle-inhibit/config.toml".text = ''
      verbosity = "WARN"
      media_minimum_duration = 5
      idle_inhibitor = "wayland"
    '';
  };
}
