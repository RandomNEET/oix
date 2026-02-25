{
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
    ./programs/hypridle
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        inherit (lib) getExe getExe';
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
        keybinds = getExe (
          import ./scripts/keybinds.nix {
            inherit
              osConfig
              config
              lib
              pkgs
              opts
              ;
          }
        );
        gamemode = ./scripts/gamemode.sh;
      in
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
                clip-manager
                screenshot
                autoclicker
                keybinds
                gamemode
                getExe
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
          brightnessctl
          cliphist
          grim
          hyprpicker
          libnotify
          slurp
          swappy
          wl-clipboard
          wlrctl
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
