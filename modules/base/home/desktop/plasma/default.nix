{
  inputs,
  osConfig,
  lib,
  pkgs,
  meta,
  ...
}:
let
  plasmaEnabled = osConfig.desktop.plasma.enable;
in
{
  imports = lib.optionals plasmaEnabled [
    (
      if (meta.channel == "unstable") then
        inputs.plasma-manager.homeModules.plasma-manager
      else
        inputs.plasma-manager-stable.homeModules.plasma-manager
    )
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/i18n/fcitx5
  ];

  config =
    if plasmaEnabled then
      {
        programs.plasma = {
          enable = true;
          configFile = {
            kwinrc.Plugins.krohnkiteEnabled = true;
          };
        };
        home.packages = with pkgs; [ kdePackages.krohnkite ];
      }
      // lib.optionalAttrs osConfig.desktop.themes.enable {
        stylix.targets.kde.enable = true;
      }
    else
      { };
}
