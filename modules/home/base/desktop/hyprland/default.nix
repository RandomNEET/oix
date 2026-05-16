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
  screenshot = getExe (import ../shared/scripts/screenshot.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  keybinds = getExe (
    import ./scripts/keybinds.nix {
      inherit
        osConfig
        config
        lib
        pkgs
        ;
    }
  );
  gamespace = getExe (pkgs.callPackage ../shared/scripts/gamespace.nix { inherit pkgs; });
in
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia-shell
    ../shared/programs/rofi
    ../shared/services/cliphist
    ../shared/services/udiskie
    ../shared/services/wayland-pipewire-idle-inhibit
  ];

  config = lib.mkIf osConfig.desktop.hyprland.enable {
    wayland.windowManager.hyprland =
      let
        mkLuaInline = lib.generators.mkLuaInline;
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
            keybinds
            gamespace
            ;
        };
        rules = import ./rules.nix;
        plugins = import ./plugins.nix { inherit pkgs; };
      in
      {
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          env = import ./env.nix;
          on = import ./autostart.nix { inherit lib mkLuaInline; };
          inherit (binds) bind define_submap;
          inherit (rules) layer_rule window_rule;
          inherit (plugins) config;
        }
        // import ./misc.nix;
        inherit (plugins) plugins;
      };

    services.hyprpolkitagent.enable = true;

    xdg = {
      enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        xdgOpenUsePortal = true;
        config = {
          common = {
            default = "gtk";
          };
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.OpenURI" = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
            "org.freedesktop.impl.portal.Print" = "gtk";
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
      hyprpicker
      wlrctl # mouse control
      yad # keybinds script
      # clipboard
      cliphist
      wl-clipboard
      # screenshot
      grim
      slurp
      swappy
    ];
  };
}
