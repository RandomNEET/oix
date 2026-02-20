{
  inputs,
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/programs/fcitx5
    ../shared/programs/gowall
    ../shared/programs/rofi
    ../shared/programs/swaync
    ../shared/programs/swww
    ../shared/programs/waybar
    ../shared/programs/wlogout
    ./programs/swayidle
    ./programs/swaylock
  ];

  programs.niri = {
    enable = true;
  };

  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        inherit (lib) getExe;
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        launcher = getExe (
          import ../shared/scripts/launcher.nix {
            inherit
              config
              lib
              pkgs
              mylib
              opts
              ;
          }
        );
        random-wall = getExe (
          import ../shared/scripts/random-wall.nix {
            inherit
              config
              pkgs
              mylib
              opts
              ;
          }
        );
        randomwallctl = import ../shared/scripts/randomwallctl.nix { inherit lib pkgs opts; };
        clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
        autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
      in
      {
        imports = [
          inputs.niri.homeModules.niri
        ]
        ++ lib.optional hasThemes inputs.niri.homeModules.stylix;

        programs.niri = {
          enable = true;
          package = pkgs.niri;
          settings = {
            environment = import ./environment.nix { inherit osConfig config lib; };
            spawn-at-startup = import ./startup.nix {
              inherit
                lib
                pkgs
                opts
                randomwallctl
                getExe
                ;
            };
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
                getExe
                ;
            };
            layer-rules = (import ./rules.nix).layer-rules;
            window-rules = (import ./rules.nix).window-rules;
          }
          // (import ./misc.nix { inherit opts; });
        };

        services.lxqt-policykit-agent.enable = true;
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
            xdgOpenUsePortal = true;
            extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
            configPackages = [ pkgs.xdg-desktop-portal-gtk ];
            config.common.default = "gtk";
          };
        };

        home.packages = with pkgs; [
          brightnessctl
          cliphist
          inotify-tools
          libnotify
          networkmanagerapplet
          pamixer
          pavucontrol
          playerctl
          wl-clipboard
          wlsunset
          xwayland-satellite
        ];
      }
      // lib.optionalAttrs hasThemes {
        stylix.targets.niri.enable = true;
      }
    )
  ];
}
