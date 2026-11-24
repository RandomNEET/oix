{
  osConfig,
  config,
  lib,
  pkgs,
}:
let
  themeSwitcherEnabled =
    (osConfig.oix.desktop.themes.enable or false)
    && builtins.length (osConfig.oix.desktop.themes.list or [ ]) > 1;
  hasWallpaper = config.oix.desktop.wallpaper.enable;
  restore-wall-theme = import ./scripts/restore-wall-theme.nix { inherit osConfig config pkgs; };
in
{
  rebooting = lib.mkIf (hasWallpaper && themeSwitcherEnabled) "${restore-wall-theme}";
  shutting_down = lib.mkIf (hasWallpaper && themeSwitcherEnabled) "${restore-wall-theme}";
}
