{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ]
        ++ lib.optional config.desktop.hyprland.enable xdg-desktop-portal-hyprland;
      configPackages =
        with pkgs;
        [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ]
        ++ lib.optional config.desktop.hyprland.enable xdg-desktop-portal-hyprland;
      config = {
        common = {
          default = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      }
      // lib.optionalAttrs config.desktop.hyprland.enable {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.Print" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
