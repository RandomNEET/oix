{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./options.nix
  ];

  services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    udisks2.enable = true;
    xserver.enable = config.oix.desktop.plasma.x11Support;
  };

  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    configPackages = [ pkgs.kdePackages.plasma-workspace ];
  };

  environment.etc = lib.optionalAttrs (config.oix.desktop.ly.enable or false) (
    {
      "ly/sessions/wayland/plasma-wayland.desktop".text = ''
        [Desktop Entry]
        Name=plasma-wayland
        Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
        DesktopNames=KDE
      '';
    }
    // lib.optionalAttrs config.oix.desktop.plasma.x11Support {
      "ly/sessions/x/plasma-x11.desktop".text = ''
        [Desktop Entry]
        Name=plasma-x11
        Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11
        DesktopNames=KDE
      '';
    }
  );
}
