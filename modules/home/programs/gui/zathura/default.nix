{ osConfig, lib, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard
    '';
  };

  stylix.targets.zathura.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
