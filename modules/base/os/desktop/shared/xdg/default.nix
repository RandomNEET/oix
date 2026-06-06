{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional;
in
{
  config = lib.mkIf config.desktop.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals =
          with pkgs;
          [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
          ]
          ++ optional config.desktop.hyprland.enable xdg-desktop-portal-hyprland
          ++ optional config.desktop.plasma.enable kdePackages.xdg-desktop-portal-kde;
        configPackages =
          with pkgs;
          [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
          ]
          ++ optional config.desktop.hyprland.enable xdg-desktop-portal-hyprland
          ++ optional config.desktop.plasma.enable kdePackages.plasma-workspace;
      };
    };
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
