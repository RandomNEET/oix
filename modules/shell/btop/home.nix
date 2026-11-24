{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  programs.btop = {
    enable = true;
    package = if ((osConfig.oix.hardware.gpu or "none") == "nvidia") then pkgs.btop-cuda else pkgs.btop;
    settings = {
      vim_keys = true;
    };
  };
}
// lib.optionalAttrs (osConfig.oix.desktop.themes.enable or false) {
  stylix.targets.btop.enable = true;
}
