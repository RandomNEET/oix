{ config, lib, ... }:
{
  environment.etc = lib.optionalAttrs config.services.displayManager.ly.enable {
    "ly/sessions/wayland/niri.desktop".text = ''
      [Desktop Entry]
      Name=niri
      Exec=niri-session
      DesktopNames=niri
    '';
  };
}
