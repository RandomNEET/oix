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
    ../shared/programs/noctalia
    ../shared/programs/rofi
    ./programs/swayidle
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
        clip-manager = getExe (import ../shared/scripts/clip-manager.nix { inherit pkgs; });
        screenshot = getExe (import ../shared/scripts/screenshot.nix { inherit config pkgs; });
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
            environment = import ./environment.nix;
            spawn-at-startup = import ./startup.nix {
              inherit
                lib
                pkgs
                opts
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
                clip-manager
                screenshot
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
            config.common.default = "gtk";
          };
        };

        home.packages = with pkgs; [
          brightnessctl
          cliphist
          grim
          libnotify
          slurp
          swappy
          wl-clipboard
          xwayland-satellite
        ];
      }
      // lib.optionalAttrs hasThemes {
        stylix.targets.niri.enable = true;
      }
    )
  ];
}
