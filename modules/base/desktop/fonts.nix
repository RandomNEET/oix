{ config, lib, ... }:
let
  fonts = config.desktop.fonts;
in
{
  config = lib.mkIf config.desktop.enable {
    fonts.packages = [
      fonts.monospace.package
      fonts.sansSerif.package
      fonts.serif.package
      fonts.emoji.package
    ];
  };
}
