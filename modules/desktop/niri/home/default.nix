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
  fileManagerExe = getExe (import ../../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../../shared/scripts/autoclicker.nix { });
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
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
                osConfig
                config
                lib
                fileManagerExe
                autoclicker
                ;
            };
            _children = import ./startup.nix ++ import ./rules.nix;
          }
          // import ./misc.nix
        )
        (
          lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
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
