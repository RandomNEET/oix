{ osConfig, lib, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  stylix.targets.btop.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
