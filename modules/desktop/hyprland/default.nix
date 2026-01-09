{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) getExe getExe';
  launcher = getExe (
    import ../shared/scripts/launcher.nix {
      inherit
        config
        lib
        pkgs
        opts
        ;
    }
  );
  random-wall = getExe (import ../shared/scripts/random-wall.nix { inherit config pkgs opts; });
  randomwallctl = ../shared/scripts/randomwallctl.sh;
  powermodectl = import ../shared/scripts/powermodectl.nix { inherit config pkgs; };
  clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs opts; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  keybinds = getExe (
    import ./scripts/keybinds.nix {
      inherit
        config
        lib
        pkgs
        opts
        ;
    }
  );
  screenshot = ./scripts/screenshot.sh;
  gamemode = ./scripts/gamemode.sh;
in
{
  imports = [
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/rofi
    ../shared/programs/swaync
    ../shared/programs/swww
    ../shared/programs/waybar
    ../shared/programs/wlogout
    ./programs/hypridle
    ./programs/hyprlock
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      {
        wayland.windowManager.hyprland =
          let
            binds = import ./binds.nix {
              inherit
                osConfig
                config
                lib
                pkgs
                opts
                launcher
                random-wall
                clip-manager
                autoclicker
                keybinds
                screenshot
                gamemode
                getExe
                getExe'
                ;
            };
            plugins = import ./plugins.nix { inherit pkgs; };
          in
          {
            enable = true;
            systemd.enable = true;
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
              exec-once = import ./exec-once.nix {
                inherit
                  osConfig
                  lib
                  pkgs
                  opts
                  randomwallctl
                  powermodectl
                  getExe
                  getExe'
                  ;
              };
              layerrule = (import ./rules.nix).layerrule;
              windowrule = (import ./rules.nix).windowrule;
              inherit (plugins) plugin;
            }
            // (import ./misc.nix { inherit opts; });

            inherit (binds) submaps;
            inherit (plugins) plugins;

            extraConfig = ''
              monitor=,preferred,auto,1
              binds {
                  workspace_back_and_forth = 0
                  #allow_workspace_cycles = 1
                  #pass_mouse_when_bound = 0
                }
            ''
            + (opts.hyprland.extraConfig);
          };

        services.hyprpolkitagent.enable = true;
        # Put inside of home-manager to auto start sservice after switching specialisation
        systemd.user = {
          services.random-wall = {
            Unit = {
              Description = "Random wallpaper";
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${random-wall}";
            };
            Install = {
              WantedBy = [ "default.target" ];
            };
          };
          timers.random-wall = {
            Unit = {
              Description = "Timer for Random wallpaper";
            };
            Timer = {
              OnCalendar = "hourly";
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
          };
        };

        xdg = {
          enable = true;
          portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-gtk
            ];
            xdgOpenUsePortal = true;
            configPackages = [ config.wayland.windowManager.hyprland.package ];
            config.hyprland = {
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

        home.packages = with pkgs; [
          hyprpicker
          hyprsunset
          cliphist
          grimblast
          swappy
          libnotify
          brightnessctl
          networkmanagerapplet
          pamixer
          pavucontrol
          playerctl
          wl-clipboard
          wlrctl
          wtype
          yad
        ];
      }
    )
  ];
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
