{
  lib,
  pkgs,
  ...
}:
let
  thunar = pkgs.thunar.override {
    thunarPlugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
in
{
  config = {
    oix.defaults.fileManager = lib.mkDefault "thunar";
  }
  // {
    home.packages = with pkgs; [
      thunar
      gvfs
      tumbler
      xfconf
    ];
  };
}
