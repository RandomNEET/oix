{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) getExe;
  niriEnabled = osConfig.desktop.niri.enable;
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
in
{
  imports = lib.optionals niriEnabled (
    if (meta.channel == "unstable") then
      [
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
      ]
    else
      [
        inputs.niri-stable.homeModules.niri
        inputs.niri-stable.homeModules.stylix
      ]
      ++ [
        ../shared/fonts
        ../shared/themes
        ../shared/xdg
        ../shared/i18n/fcitx5
        ../shared/programs/gowall
        ../shared/programs/noctalia
        ../shared/services/udiskie
      ]
  );

  config =
    if niriEnabled then
      {
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

        xdg.configFile.niri-config.source =
          let
            inherit (inputs.niri.lib.internal) validated-config-for;
            inherit (config.programs.niri) finalConfig package;
          in
          lib.mkForce (
            validated-config-for pkgs package ''
              ${finalConfig}

              window-rule {
                background-effect {
                  blur true
                  xray false
                }
              }
            ''
          );
      }
      // lib.optionalAttrs osConfig.desktop.themes.enable {
        stylix.targets.niri.enable = true;
      }
    else
      { };
}
