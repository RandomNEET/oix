{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  terminal = import ../misc/terminal.nix { inherit config; };
in
{
  config = lib.mkIf osConfig.desktop.enable {
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
          ++ lib.optional osConfig.desktop.hyprland.enable xdg-desktop-portal-hyprland;
        configPackages =
          with pkgs;
          [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-termfilechooser
          ]
          ++ lib.optional osConfig.desktop.hyprland.enable xdg-desktop-portal-hyprland;
        config = {
          common = {
            default = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          };
        }
        // lib.optionalAttrs osConfig.desktop.hyprland.enable {
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
  };
}
