{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.etc = lib.optionalAttrs config.services.displayManager.ly.enable {
    "ly/sessions/wayland/hyprland.desktop".text = ''
      [Desktop Entry]
      Name=hyprland
      Exec=start-hyprland
      DesktopNames=Hyprland
    '';
  };
}
