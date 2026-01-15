{ pkgs, ... }:
{
  plugins = with pkgs; [
    # hyprlandPlugins.hyprspace
  ];
  plugin = {
    # overview = {
    #   disableBlur = true;
    #   onBottom = true;
    #   centerAligned = true;
    # };
  };
}
