{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  hasThemes = config.desktop.themes.enable;
  launcher = getExe (import ../shared/scripts/launcher.nix { inherit config lib pkgs; });
  clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  screenshot = getExe (import ../shared/scripts/screenshot.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
    ../shared/fonts
    ../shared/themes
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia-shell
    ../shared/programs/rofi
    ../shared/services/cliphist
    ../shared/services/wayland-pipewire-idle-inhibit
  ];

  config = lib.mkIf config.desktop.niri.enable {
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
            screenshot
            autoclicker
            getExe
            ;
        };
        layer-rules = (import ./rules.nix).layer-rules;
        window-rules = (import ./rules.nix).window-rules;
      }
      // import ./misc.nix;
    };

    services.lxqt-policykit-agent.enable = true;
    systemd.user = {
      services.lxqt-policykit-agent = {
        Unit = {
          After = [ "graphical-session.target" ];
        };
      };
    };

    xdg = {
      enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        configPackages = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
          common = {
            default = "gtk";
          };
        };
      };
      terminal-exec = {
        enable = true;
        settings = {
          default = [ "${config.defaultPrograms.terminal}.desktop" ];
        };
      };
    };

    home.packages = with pkgs; [
      libnotify
      xwayland-satellite
      # clipboard
      cliphist
      wl-clipboard
      # screenshot
      grim
      slurp
      swappy
    ];
    stylix.targets =
      { }
      // lib.optionalAttrs hasThemes {
        niri.enable = true;
      };
  };
}
