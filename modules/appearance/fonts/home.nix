{
  osConfig,
  lib,
  meta,
  ...
}:
let
  cfg = osConfig.oix.appearance.fonts;
in
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = map (f: f.name) cfg.monospace;
      sansSerif = map (f: f.name) cfg.sansSerif;
      serif = map (f: f.name) cfg.serif;
      emoji = map (f: f.name) cfg.emoji;
    };
  };
  home.packages = lib.mkIf (meta.platform == "home-manager") (
    builtins.concatLists [
      (map (f: f.package) cfg.monospace)
      (map (f: f.package) cfg.sansSerif)
      (map (f: f.package) cfg.serif)
      (map (f: f.package) cfg.emoji)
    ]
  );
}
