{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional optionalAttrs;
  terminal = import ../scripts/terminal.nix { inherit config; };
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
        ++ optional (osConfig.oix.desktop.hyprland.enable or false) xdg-desktop-portal-hyprland
        ++ optional (osConfig.oix.desktop.mango.enable or false) xdg-desktop-portal-wlr
        ++ optional (osConfig.oix.desktop.plasma.enable or false) kdePackages.xdg-desktop-portal-kde;
      configPackages =
        with pkgs;
        [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-termfilechooser
        ]
        ++ optional (osConfig.oix.desktop.hyprland.enable or false) xdg-desktop-portal-hyprland
        ++ optional (osConfig.oix.desktop.mango.enable or false) xdg-desktop-portal-wlr
        ++ optional (osConfig.oix.desktop.plasma.enable or false) kdePackages.plasma-workspace;
      config = {
        common = {
          default = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      }
      // optionalAttrs (osConfig.oix.desktop.hyprland.enable or false) {
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
      // optionalAttrs (osConfig.oix.desktop.mango.enable or false) {
        mango = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.ScreenShot" = "wlr";
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      }
      // optionalAttrs (osConfig.oix.desktop.plasma.enable or false) {
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
        default = [ "${(config.oix.defaults.terminal or null)}.desktop" ];
      };
    };
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${(config.oix.defaults.fileManager or null)}-wrapper.sh
      default_dir=$HOME
      env=TERMCMD='${terminal.exe} ${terminal.classFlag} "terminal filechooser"'
      open_mode=suggested
      save_mode=suggested
    '';
  };
}
