{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional optionalAttrs;
  terminal = import ../misc/terminal.nix { inherit config; };
in
{
  xdg = {
    enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ]
        ++ optional osConfig.desktop.hyprland.enable xdg-desktop-portal-hyprland
        ++ optional osConfig.desktop.mango.enable xdg-desktop-portal-wlr
        ++ optional osConfig.desktop.plasma.enable kdePackages.xdg-desktop-portal-kde;
      configPackages =
        with pkgs;
        [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ]
        ++ optional osConfig.desktop.hyprland.enable xdg-desktop-portal-hyprland
        ++ optional osConfig.desktop.mango.enable xdg-desktop-portal-wlr
        ++ optional osConfig.desktop.plasma.enable kdePackages.plasma-workspace;
      config = {
        common = {
          default = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      }
      // optionalAttrs osConfig.desktop.hyprland.enable {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.Print" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      }
      // optionalAttrs osConfig.desktop.mango.enable {
        mango = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.ScreenShot" = "wlr";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      }
      // optionalAttrs osConfig.desktop.plasma.enable {
        KDE = {
          default = [
            "gtk"
            "kde"
          ];
        };
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "${config.defaultPrograms.terminal}.desktop" ];
      };
    };
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${config.defaultPrograms.fileManager}-wrapper.sh
      default_dir=$HOME
      env=TERMCMD='${terminal.exe} ${terminal.classFlag} "terminal filechooser"'
      open_mode=suggested
      save_mode=suggested
    '';
  };
}
