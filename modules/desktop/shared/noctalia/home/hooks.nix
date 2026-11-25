{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  themeSwitcherEnabled =
    (osConfig.oix.appearance.themes.enable or false)
    && builtins.length (osConfig.oix.appearance.themes.list or [ ]) > 1;
  wallpaperEnabled = config.oix.desktop.wallpaper.enable;
  restoreWallTheme = import ./scripts/restore-wall-theme.nix { inherit osConfig config pkgs; };
in
{
  rebooting = lib.mkIf (wallpaperEnabled && themeSwitcherEnabled) "${restoreWallTheme}";
  shutting_down = lib.mkIf (wallpaperEnabled && themeSwitcherEnabled) "${restoreWallTheme}";
}
