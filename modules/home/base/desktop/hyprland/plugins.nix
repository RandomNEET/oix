{ pkgs, ... }:
{
  plugins = with pkgs.hyprlandPlugins; [ ];
  config = {
    plugin = { };
  };
}
