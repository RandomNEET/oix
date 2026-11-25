{ osConfig, lib, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
    '';
  };
}
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.zathura.enable = true;
}
