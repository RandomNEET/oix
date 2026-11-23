{
  lib,
  config,
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
  config = lib.mkIf config.defaultPrograms.fileManager.thunar.enable ({
    home.packages = with pkgs; [
      thunar
      gvfs
      tumbler
      xfconf
    ];
  });
}
