{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.etc = lib.mkMerge [
    (lib.optionalAttrs config.desktop.hyprland.enable {
      "greetd/sessions/hyprland.desktop".text = ''
        [Desktop Entry]
        Name=hyprland
        Exec=start-hyprland
      '';
    })
    (lib.optionalAttrs config.desktop.niri.enable {
      "greetd/sessions/niri.desktop".text = ''
        [Desktop Entry]
        Name=niri
        Exec=niri-session
      '';
    })
    (lib.optionalAttrs config.desktop.plasma.enable {
      "greetd/sessions/plasma.desktop".text = ''
        [Desktop Entry]
        Name=plasma
        Exec=env QT_QPA_PLATFORMTHEME=kde ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed ${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
      '';
    })
    (lib.optionalAttrs config.programs.zsh.enable {
      "greetd/sessions/zsh.desktop".text = ''
        [Desktop Entry]
        Name=zsh
        Exec=zsh
      '';
    })
  ];
}
