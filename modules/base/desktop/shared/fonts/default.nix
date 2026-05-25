{ config, lib, ... }:
let
  fonts = config.desktop.fonts;
in
{
  config = lib.mkIf config.desktop.enable {
    fonts.packages = builtins.concatLists [
      (map (f: f.package) fonts.monospace)
      (map (f: f.package) fonts.sansSerif)
      (map (f: f.package) fonts.serif)
      (map (f: f.package) fonts.emoji)
    ];
  };
}
