{
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
{
  imports = [
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
        inherit (lib) optionalString getExe;
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
        random-wall = getExe (import ../shared/scripts/random-wall.nix { inherit config pkgs opts; });
        randomwallctl = import ../shared/scripts/randomwallctl.nix { inherit lib pkgs opts; };
        clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
        autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });

        niriConfig = ''
          ${lib.concatMapStringsSep "\n" (
            output:
            optionalString ((output.name or "") != "") ''
              output "${output.name}" {
                ${optionalString (output.off or false) "off"}
                ${optionalString ((output.mode or "") != "") ''mode "${output.mode}"''}
                ${optionalString ((output.scale or null) != null) "scale ${builtins.toJSON output.scale}"}
                ${optionalString ((output.transform or "") != "") ''transform "${output.transform}"''}
                ${
                  optionalString (
                    (((output.position.x or null) != null) && ((output.position.y or null) != null))
                  ) "position x=${toString output.position.x} y=${toString output.position.y}"
                } 
                ${optionalString (output.variable-refresh-rate or false) "variable-refresh-rate"}
                ${optionalString (output.focus-at-startup or false) "focus-at-startup"}
                ${optionalString (
                  (output.backdrop-color or "") != ""
                ) ''backdrop-color "${output.backdrop-color}"''}
                ${optionalString ((output.hot-corners or null) != null) ''
                  hot-corners {
                    ${optionalString (output.hot-corners.off or false) "off"}
                    ${optionalString (output.hot-corners.top-left or false) "top-left"}
                    ${optionalString (output.hot-corners.top-right or false) "top-right"}
                    ${optionalString (output.hot-corners.bottom-left or false) "bottom-left"}
                    ${optionalString (output.hot-corners.bottom-right or false) "bottom-right"}
                  }
                ''}
              }
            ''
          ) opts.niri.output}

          input {
              touchpad {
                  tap
                  natural-scroll
              }
          }

          ${import ./rules.nix}
          ${import ./misc.nix}
          ${import ./environment.nix {
            inherit
              osConfig
              config
              lib
              optionalString
              ;
          }}
          ${import ./startup.nix {
            inherit
              osConfig
              pkgs
              opts
              randomwallctl
              optionalString
              getExe
              ;
          }}
          ${import ./binds.nix {
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
          }}
        '';
      in
      {
        home.file.".config/niri/config.kdl".text = niriConfig;

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
    )
  ];
}
