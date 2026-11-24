{
  inputs,
  osConfig,
  lib,
  pkgs,
  meta,
  ...
}:
{
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.plasma-manager.homeModules.plasma-manager
      else
        inputs.plasma-manager-stable.homeModules.plasma-manager
    )
  ];

  config = {
    programs.plasma = {
      enable = true;
      configFile = {
        kwinrc.Plugins.krohnkiteEnabled = true;
      };
    };
    home.packages = with pkgs; [ kdePackages.krohnkite ];
  }
  // lib.optionalAttrs (osConfig.oix.desktop.themes.enable or false) {
    stylix.targets.kde.enable = true;
  };
}
