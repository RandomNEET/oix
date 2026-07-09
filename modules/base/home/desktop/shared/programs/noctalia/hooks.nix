{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
  hasWallpaper = config.desktop.wallpaper.enable;
  restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit osConfig config pkgs; };
in
{
  rebooting = lib.mkIf (hasWallpaper && themesEnabled) "${restore-wall-theme}";
  shutting_down = lib.mkIf (hasWallpaper && themesEnabled) "${restore-wall-theme}";
}
