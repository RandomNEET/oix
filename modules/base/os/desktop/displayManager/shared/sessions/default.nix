{ pkgs }:
{
  hyprland = ''
    [Desktop Entry]
    Name=hyprland
    Exec=start-hyprland
    DesktopNames=Hyprland
  '';
  niri = ''
    [Desktop Entry]
    Name=niri
    Exec=niri-session
    DesktopNames=niri
  '';
  mango = ''
    [Desktop Entry]
    Name=mango
    Exec=mango
    DesktopNames=mango;wlroots
  '';
  plasma-wayland = ''
    [Desktop Entry]
    Name=plasma-wayland
    Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
    DesktopNames=KDE
  '';
  plasma-x11 = ''
    [Desktop Entry]
    Name=plasma-x11
    Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11
    DesktopNames=KDE
  '';
  steam-gamescope = ''
    [Desktop Entry]
    Name=steam
    Exec=${pkgs.gamescope}/bin/gamescope --steam -e -- steam -tenfoot -pipewire-dmabuf
  '';
}
