{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./options.nix ];

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.etc = lib.optionalAttrs (config.oix.desktop.ly.enable or false) {
    "ly/sessions/wayland/hyprland.desktop".text = ''
      [Desktop Entry]
      Name=hyprland
      Exec=start-hyprland
      DesktopNames=Hyprland
    '';
  };
}
