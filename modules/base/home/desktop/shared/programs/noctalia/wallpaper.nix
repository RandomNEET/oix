{
  osConfig,
  config,
  lib,
  mylib,
}:
let
  hasThemes = osConfig.desktop.themes.enable;
  themeName = if hasThemes then mylib.theme.getBase16Scheme config.stylix.base16Scheme else "default";
  hasWallpaper = config.desktop.wallpaper.enable;
  wallpaperDir =
    if hasThemes then
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

  fill_mode = "crop";
  fill_color = "#111111";
  transition = [
    "fade"
    "wipe"
    "disc"
    "stripes"
    "zoom"
    "honeycomb"
  ];
  transition_duration = 1500;
  edge_smoothness = 0.3;
  transition_on_startup = false;

  automation = {
    enabled = true;
    interval_seconds = 3600;
    order = "random";
    recursive = true;
  };
}
