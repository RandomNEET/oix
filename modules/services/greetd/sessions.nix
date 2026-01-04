{ config, lib, ... }:
{
  environment.etc = lib.mkMerge [
    (lib.optionalAttrs config.programs.hyprland.enable {
      "greetd/sessions/hyprland.desktop".text = ''
        [Desktop Entry]
        Name=hyprland
        Exec=start-hyprland
        Type=Application
      '';
    })
    (lib.optionalAttrs config.programs.niri.enable {
      "greetd/sessions/niri.desktop".text = ''
        [Desktop Entry]
        Name=niri
        Exec=niri-session
        Type=Application
      '';
    })
    (lib.optionalAttrs config.programs.zsh.enable {
      "greetd/sessions/zsh.desktop".text = ''
        [Desktop Entry]
        Name=zsh
        Exec=zsh
        Type=Application
      '';
    })
  ];
}
