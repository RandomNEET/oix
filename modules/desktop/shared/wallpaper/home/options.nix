{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.desktop.wallpaper = {
    enable = mkOption {
      type = types.bool;
      default = config.oix.desktop.wallpaper.dir != null;
      defaultText = lib.literalExpression "config.oix.desktop.wallpaper.dir != null";
      readOnly = true;
      description = "Global indicator flag set automatically when `oix.desktop.wallpaper.dir` is non-null.";
    };
    dir = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Root directory storing user wallpapers. When set, custom wallpaper management and automatic `gowall` palette conversion are enabled.

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
}
