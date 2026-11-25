{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  themesEnabled = config.oix.appearance.themes.enable;
  fontsEnabled = config.oix.appearance.fonts.enable or false;
  fontsCfg = config.oix.appearance.fonts or { };
  mkStylixFont = list: mkIf (list != [ ]) { inherit (builtins.head list) package name; };
  desktopEnabled = config.oix.desktop.enable or false;
in
{
  imports = [
    ./options.nix
    (
      if (meta.channel == "unstable") then
        inputs.stylix.nixosModules.stylix
      else
        inputs.stylix-stable.nixosModules.stylix
    )
  ];

  config = mkMerge [
    (mkIf themesEnabled {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${builtins.head config.oix.appearance.themes.list}.yaml";
        polarity = config.oix.appearance.themes.polarity;
        autoEnable = false;
        targets.console.enable = true;
      };
    })

    (mkIf (themesEnabled && fontsEnabled) {
      stylix.fonts = {
        monospace = mkStylixFont (fontsCfg.monospace or [ ]);
        sansSerif = mkStylixFont (fontsCfg.sansSerif or [ ]);
        serif = mkStylixFont (fontsCfg.serif or [ ]);
        emoji = mkStylixFont (fontsCfg.emoji or [ ]);
      };
    })

    (mkIf (themesEnabled && desktopEnabled) {
      stylix.targets = {
        gtk.enable = true;
        qt.enable = true;
      };
    })
  ];
}
