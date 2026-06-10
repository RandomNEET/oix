{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
  sessions = import ../shared/sessions { inherit pkgs; };
in
{
  config = lib.mkIf (config.desktop.displayManager == "tuigreet") {
    environment.etc = lib.mkMerge [
      (optionalAttrs config.desktop.hyprland.enable {
        "greetd/sessions/hyprland.desktop".text = sessions.hyprland;
      })
      (optionalAttrs config.desktop.niri.enable {
        "greetd/sessions/niri.desktop".text = sessions.niri;
      })
      (optionalAttrs config.desktop.plasma.enable {
        "greetd/sessions/plasma-wayland.desktop".text = sessions.plasma-wayland;
        "greetd/sessions/plasma-x11.desktop".text = sessions.plasma-x11;
      })
      (optionalAttrs config.programs.zsh.enable {
        "greetd/sessions/zsh.desktop".text = sessions.zsh;
      })
    ];
  };
}
