{ config, lib, ... }:
{
  imports = [ ./options.nix ];

  environment.etc = lib.optionalAttrs (config.oix.desktop.ly.enable or false) {
    "ly/sessions/wayland/niri.desktop".text = ''
      [Desktop Entry]
      Name=niri
      Exec=niri-session
      DesktopNames=niri
    '';
  };
}
