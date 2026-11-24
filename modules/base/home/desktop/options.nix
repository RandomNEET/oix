{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkMerge
    mkIf
    mkForce
    ;
in
{
  options = {
    desktop = {
      wallpaper = {
        enable = mkEnableOption "custom wallpaper management and automatic palette conversion via gowall";
        dir = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Root directory storing user wallpapers.

            Source images should be placed under `original/<orientation>/` (where `<orientation>` is `"landscape"` or `"portrait"`).
            Palette-converted variants are generated automatically by `gowall` under `themed/<theme>/<orientation>/` and should not be edited manually:

            ```text
            wallpapers
            ├── original
            │   └── landscape
            │       └── image.jpg
            └── themed
                └── catppuccin-mocha
                    └── landscape
                        └── image.jpg
            ```
          '';
        };
      };
    };
  };
  config = mkMerge [
    (mkIf (!config.desktop.wallpaper.enable) {
      desktop.wallpaper.dir = mkForce null;
    })
  ];
}
