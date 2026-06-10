{ pkgs }:
{
  hyprland = ''
    [Desktop Entry]
    Name=hyprland
    Exec=${pkgs.hyprland}/bin/start-hyprland
    DesktopNames=Hyprland
  '';
  niri = ''
    [Desktop Entry]
    Name=niri
    Exec=${pkgs.niri}/bin/niri-session
    DesktopNames=niri
  '';
  plasma-wayland = ''
    [Desktop Entry]
    Name=plasma
    Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
    DesktopNames=KDE
  '';
  plasma-x11 = ''
    [Desktop Entry]
    Name=plasma
    Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11
    DesktopNames=KDE
  '';
  zsh = ''
    [Desktop Entry]
    Name=zsh
    Exec=${pkgs.zsh}/bin/zsh
  '';
}
