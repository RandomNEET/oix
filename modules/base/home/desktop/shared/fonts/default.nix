{ osConfig, lib, ... }:
let
  fonts = osConfig.desktop.fonts;
in
{
  config = lib.mkIf osConfig.desktop.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = map (f: f.name) fonts.monospace;
        sansSerif = map (f: f.name) fonts.sansSerif;
        serif = map (f: f.name) fonts.serif;
        emoji = map (f: f.name) fonts.emoji;
      };
    };
    home.packages = builtins.concatLists [
      (map (f: f.package) fonts.monospace)
      (map (f: f.package) fonts.sansSerif)
      (map (f: f.package) fonts.serif)
      (map (f: f.package) fonts.emoji)
    ];
  };
}
