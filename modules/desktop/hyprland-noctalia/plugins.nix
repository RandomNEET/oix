{ pkgs, ... }:
{
  plugins = with pkgs.hyprlandPlugins; [
    hyprspace
  ];
  plugin = {
    overview = {
      disableBlur = true;
      onBottom = true;
      centerAligned = true;
      hideRealLayers = false;
      affectStrut = false; # https://github.com/KZDKM/Hyprspace/issues/217
    };
  };
}
