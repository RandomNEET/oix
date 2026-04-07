{ config, lib, ... }:
let
  fonts = config.desktop.themes.fonts;
in
{
  config = lib.mkIf config.desktop.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ fonts.monospace.name ];
        sansSerif = [ fonts.sansSerif.name ];
        serif = [ fonts.serif.name ];
        emoji = [ fonts.emoji.name ];
      };
    };
    home.packages = [
      fonts.monospace.package
      fonts.sansSerif.package
      fonts.serif.package
      fonts.emoji.package
    ];
  };
}
