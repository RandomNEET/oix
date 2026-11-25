{
  osConfig,
  config,
  lib,
  mylib,
}:
let
  themesEnabled = osConfig.oix.appearance.themes.enable or false;
  themeName =
    if themesEnabled then mylib.theme.getBase16Scheme config.stylix.base16Scheme else "default";
  hasWallpaper = config.oix.desktop.wallpaper.enable;
  wallpaperDir =
    if themesEnabled then
      "${config.oix.desktop.wallpaper.dir}/themed/${themeName}"
    else
      config.oix.desktop.wallpaper.dir;
in
{
  enabled = true;
  directory = wallpaperDir;
  per_monitor_directories = true;
  monitor = lib.mkIf (hasWallpaper && (osConfig.oix.hardware.display.info or [ ]) != [ ]) (
    builtins.listToAttrs (
      map (d: {
        name = d.output;
        value = {
          enabled = true;
          directory = "${wallpaperDir}/${d.orientation}";
        };
      }) (osConfig.oix.hardware.display.info or [ ])
    )
  );

  automation = {
    enabled = true;
    interval_seconds = 3600;
    recursive = true;
  };
}
