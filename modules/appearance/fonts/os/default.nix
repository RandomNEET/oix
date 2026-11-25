{ config, ... }:
let
  fonts = config.oix.appearance.fonts;
in
{
  imports = [ ./options.nix ];

  fonts.packages = builtins.concatLists [
    (map (f: f.package) fonts.monospace)
    (map (f: f.package) fonts.sansSerif)
    (map (f: f.package) fonts.serif)
    (map (f: f.package) fonts.emoji)
  ];
}
