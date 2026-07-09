{ osConfig, lib, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
    '';
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.zathura.enable = true;
}
