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
        monospace = config.desktop.fonts.monospace;
        sansSerif = config.desktop.fonts.sansSerif;
        serif = config.desktop.fonts.serif;
        emoji = config.desktop.fonts.emoji;
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
