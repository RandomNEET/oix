{
  osConfig,
  config,
  lib,
  mylib,
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
  themeName =
    if themesEnabled then mylib.theme.getBase16Scheme config.stylix.base16Scheme else "default";
  hasWallpaper = config.desktop.wallpaper.enable;
  wallpaperDir =
    if themesEnabled then
      "${config.desktop.wallpaper.dir}/themed/${themeName}"
    else
      config.desktop.wallpaper.dir;
in
{
  enabled = true;

  directory = wallpaperDir;
  per_monitor_directories = true;
  monitor = lib.mkIf (hasWallpaper && osConfig.base.display.info != [ ]) (
    builtins.listToAttrs (
      map (d: {
        name = d.output;
        value = {
          enabled = true;
          directory = "${wallpaperDir}/${d.orientation}";
        };
      }) osConfig.base.display.info
    )
  );

  transition = [
    "fade"
    "wipe"
    "disc"
    "stripes"
    "zoom"
    "honeycomb"
    "vortex"
    "pixel"
    "diamond"
    "golden"
    "melt"
  ];

  automation = {
    enabled = true;
    interval_seconds = 3600;
    recursive = true;
  };
}
