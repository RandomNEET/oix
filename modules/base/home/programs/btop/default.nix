{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
    package = if (osConfig.base.gpu == "nvidia") then pkgs.btop-cuda else pkgs.btop;
    settings = {
      vim_keys = true;
    };
  };

  stylix.targets.btop.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
