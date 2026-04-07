{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./options.nix
  ];
  config = lib.mkIf config.desktop.enable {
    stylix = {
      enable = config.desktop.theme.enable;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.desktop.theme.baseTheme}.yaml";
      polarity = config.desktop.theme.polarity;
      fonts = {
        monospace = config.desktop.theme.fonts.monospace;
        sansSerif = config.desktop.theme.fonts.sansSerif;
        serif = config.desktop.theme.fonts.serif;
        emoji = config.desktop.theme.fonts.emoji;
      };
      autoEnable = false;
      targets = {
        console.enable = true;
      };
      homeManagerIntegration = {
        autoImport = false;
        followSystem = false;
      };
    };
  };
}
