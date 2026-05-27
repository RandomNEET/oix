{ osConfig, lib, ... }:
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/programs/fcitx5
  ];

  config = lib.mkIf osConfig.desktop.plasma.enable {
    stylix.targets = lib.mkIf osConfig.desktop.themes.enable {
      qt.enable = lib.mkForce false;
      kde.enable = true;
    };
  };
}
