{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  hasThemes = osConfig.desktop.themes.enable;
  hasWallpaper = config.desktop.wallpaper.enable;
  restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit osConfig config pkgs; };
in
{
  rebooting = lib.mkIf (hasWallpaper && hasThemes) "${restore-wall-theme}";
  shutting_down = lib.mkIf (hasWallpaper && hasThemes) "${restore-wall-theme}";
}
