{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  launcher = getExe (import ../shared/scripts/launcher.nix { inherit config lib pkgs; });
  clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
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

  config = lib.mkIf config.desktop.hyprland.enable {
    wayland.windowManager.hyprland =
      let
        binds = import ./binds.nix {
          inherit
            osConfig
            config
            lib
            pkgs
            launcher
            clip-manager
            screenshot
            autoclicker
            keybinds
            gamespace
            ;
        };
        plugins = import ./plugins.nix { inherit pkgs; };
      in
      {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          inherit (binds)
            "$mainMod"
            "$terminal"
            "$fileManager"
            "$editor"
            "$browser"
            ;
          inherit (binds) binde bind bindm;
          env = import ./env.nix { inherit lib osConfig; };
          exec-once = import ./exec-once.nix;
          layerrule = (import ./rules.nix).layerrule;
          windowrule = (import ./rules.nix).windowrule;
          inherit (plugins) plugin;
        }
        // import ./misc.nix;

        inherit (binds) submaps;
        inherit (plugins) plugins;

        extraConfig = ''
          monitor=,preferred,auto,1
          binds {
              workspace_back_and_forth = 0
              #allow_workspace_cycles = 1
              #pass_mouse_when_bound = 0
            }
        '';
      };

    services.hyprpolkitagent.enable = true;

    xdg = {
      enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
        xdgOpenUsePortal = true;
        configPackages = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
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
