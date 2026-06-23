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
      (optionalAttrs config.desktop.mango.enable {
        "ly/sessions/wayland/mango.desktop".text = sessions.mango;
      })
      (
        optionalAttrs config.desktop.plasma.enable {
          "ly/sessions/wayland/plasma-wayland.desktop".text = sessions.plasma-wayland;
        }
        // optionalAttrs config.desktop.plasma.x11Support {
          "ly/sessions/x/plasma-x11.desktop".text = sessions.plasma-x11;
        }
      )
      (optionalAttrs config.base.gaming.enable {
        "ly/sessions/wayland/steam.desktop".text = sessions.steam-gamescope;
      })
    ];
  };
}
