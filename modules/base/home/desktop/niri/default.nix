{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  inherit (lib) getExe;
  niriEnabled = osConfig.desktop.niri.enable;
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  imports = lib.optionals niriEnabled [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/i18n/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia
    ../shared/services/udiskie
  ];

  config =
    if niriEnabled then
      {
        wayland.windowManager.niri = {
          enable = true;
          package = pkgs.niri;
          settings =
            lib.recursiveUpdate
              (
                {
                  environment = import ./environment.nix;
                  layout = import ./layout.nix;
                  binds = import ./binds.nix {
                    inherit
                      config
                      lib
                      file-manager
                      autoclicker
                      getExe
                      ;
                  };
                  _children = import ./startup.nix ++ import ./rules.nix;
                }
                // import ./misc.nix
              )
              (
                lib.optionalAttrs osConfig.desktop.themes.enable {
                  layout.border = {
                    active-color = primaryColor;
                    inactive-color = colors.base03;
                  };
                }
              );
        };

        home.packages = with pkgs; [
          libnotify
          wl-clipboard
        ];
      }
    else
      { };
}
