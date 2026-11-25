{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  fileManagerExe = getExe (import ../../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../../shared/scripts/autoclicker.nix { });
  gamespace = getExe (pkgs.callPackage ./scripts/gamespace.nix { inherit pkgs; });
in
{
  config = {
    wayland.windowManager.hyprland =
      let
        binds = import ./binds.nix {
          inherit
            osConfig
            config
            lib
            fileManagerExe
            autoclicker
            gamespace
            ;
        };
        rules = import ./rules.nix;
        animations = import ./animations.nix;
        plugins = import ./plugins.nix { inherit pkgs; };
      in
      {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
        systemd = {
          enable = true;
          enableXdgAutostart = true;
        };
        xwayland.enable = true;
        settings = {
          on = import ./autostart.nix { inherit lib; };
          env = import ./env.nix;
          inherit (binds) bind define_submap;
          inherit (animations) animation curve;
          inherit (rules) layer_rule window_rule;
          inherit (plugins) config;
        }
        // import ./misc.nix;
        inherit (plugins) plugins;
      };

    home.packages = with pkgs; [
      libnotify
      wl-clipboard
      hyprpicker
      wlrctl # mouse control
    ];
  }
  // lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
    stylix.targets.hyprland.enable = true;
  };
}
