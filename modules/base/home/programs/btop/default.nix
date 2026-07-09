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
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.btop.enable = true;
}
