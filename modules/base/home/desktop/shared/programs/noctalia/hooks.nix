{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  themeSwitcherEnabled =
    osConfig.desktop.themes.enable && builtins.length osConfig.desktop.themes.list > 1;
  hasWallpaper = config.desktop.wallpaper.enable;
  restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit osConfig config pkgs; };
in
{
  rebooting = lib.mkIf (hasWallpaper && themeSwitcherEnabled) "${restore-wall-theme}";
  shutting_down = lib.mkIf (hasWallpaper && themeSwitcherEnabled) "${restore-wall-theme}";
}
