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
        enable = mkEnableOption "custom wallpaper management and automatic theme-based color conversion";
        dir = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The root directory for system wallpapers.

            Hierarchy Rules:
            1. Source: "original/" is the source of truth. Place new wallpapers here.
            2. Generated: "themed/" is managed by the autoconvert script. Do not manually edit.
            3. Path Logic:
               - Original: <base> / original / <orientation> / <file>
               - Themed:   <base> / themed   / <theme_name> / <orientation> / <file>

            Valid Orientations: "landscape", "portrait"

            Example Tree:
            wallpapers
            ├── original                  # Source files
            │   └── landscape
            │       └── image.jpg
            └── themed                    # Auto-generated files
                └── catppuccin-mocha      # Target theme palette
                    └── landscape
                        └── image.jpg
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
