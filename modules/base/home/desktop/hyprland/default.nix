{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  hyprlandEnabled = osConfig.desktop.hyprland.enable;
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  gamespace = getExe (pkgs.callPackage ./scripts/gamespace.nix { inherit pkgs; });
in
{
  imports = lib.optionals hyprlandEnabled [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/i18n/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia
    ../shared/services/udiskie
  ];

  config =
    lib.mkIf hyprlandEnabled {
      wayland.windowManager.hyprland =
        let
          binds = import ./binds.nix {
            inherit
              osConfig
              config
              lib
              file-manager
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
    // lib.optionalAttrs osConfig.desktop.themes.enable {
      stylix.targets.hyprland.enable = true;
    };

}
