{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  launcher = getExe (
    import ../shared/scripts/launcher.nix {
      inherit
        osConfig
        config
        lib
        pkgs
        ;
    }
  );
  clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
in
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia
    ../shared/programs/rofi
    ../shared/services/cliphist
    ../shared/services/udiskie
    ../shared/services/wayland-pipewire-idle-inhibit
  ];

  config = lib.mkIf osConfig.desktop.niri.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        environment = import ./environment.nix;
        spawn-at-startup = import ./startup.nix;
        binds = import ./binds.nix {
          inherit
            osConfig
            config
            lib
            pkgs
            launcher
            clip-manager
            file-manager
            autoclicker
            getExe
            ;
        };
        layer-rules = (import ./rules.nix).layer-rules;
        window-rules = (import ./rules.nix).window-rules;
      }
      // import ./misc.nix;
    };

    home.packages = with pkgs; [
      libnotify
      wl-clipboard
      xwayland-satellite
    ];

    stylix.targets.niri.enable = lib.mkIf osConfig.desktop.themes.enable true;
  };
}
