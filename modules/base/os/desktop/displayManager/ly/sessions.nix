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
  config = lib.mkIf (config.desktop.displayManager == "ly") {
    environment.etc = lib.mkMerge [
      (optionalAttrs config.desktop.hyprland.enable {
        "ly/sessions/wayland/hyprland.desktop".text = sessions.hyprland;
      })
      (optionalAttrs config.desktop.niri.enable {
        "ly/sessions/wayland/niri.desktop".text = sessions.niri;
      })
      (optionalAttrs config.desktop.plasma.enable {
        "ly/sessions/wayland/plasma-wayland.desktop".text = sessions.plasma-wayland;
        "ly/sessions/x/plasma-x11.desktop".text = sessions.plasma-x11;
      })
      (optionalAttrs config.programs.zsh.enable {
        "ly/sessions/zsh.desktop".text = sessions.zsh;
      })
    ];
  };
}
