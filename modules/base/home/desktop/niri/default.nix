{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
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
            config
            lib
            pkgs
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
