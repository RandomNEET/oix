{ osConfig, lib, ... }:
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/programs/fcitx5
  ];

  config = lib.mkIf osConfig.desktop.plasma.enable {
    stylix.targets.kde.enable = lib.mkIf osConfig.desktop.themes.enable true;
  };
}
