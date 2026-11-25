{ config, ... }:
let
  cfg = config.oix.appearance.fonts;
in
{
  imports = [ ./options.nix ];

  fonts.packages = builtins.concatLists [
    (map (f: f.package) cfg.monospace)
    (map (f: f.package) cfg.sansSerif)
    (map (f: f.package) cfg.serif)
    (map (f: f.package) cfg.emoji)
  ];
}
