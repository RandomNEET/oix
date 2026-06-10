{ config, lib, ... }:
{
  config = lib.mkIf (config.desktop.displayManager == "ly") {
    services.displayManager.ly = {
      enable = true;
      settings = {
        waylandsessions = "/etc/ly/sessions/wayland";
        custom_sessions = "/etc/ly/sessions";
        xsessions = if config.desktop.plasma.enable then "/etc/ly/sessions/x" else null;
        xinitrc = null;
        shell = false;
        session_log = ".local/state/ly/session.log";

        vi_mode = true;
        vi_default_mode = "insert";
        default_input = "password";

        clock = "%H:%M:%S %Y/%m/%d";
        animation = "matrix";
        full_color = true;
        text_in_center = true;
        hide_version_string = true;

        save = true;
      };
    };
  };
  imports = [ ./sessions.nix ];
}
