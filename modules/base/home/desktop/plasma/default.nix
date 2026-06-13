{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/programs/fcitx5
  ];

  config = lib.mkIf osConfig.desktop.plasma.enable {
    programs.plasma = {
      enable = true;
      configFile = {
        kwinrc.Plugins.krohnkiteEnabled = true;
      };
    };
    home.packages = with pkgs; [ kdePackages.krohnkite ];

    stylix.targets.kde.enable = lib.mkIf osConfig.desktop.themes.enable true;
  };
}
