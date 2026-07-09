{
  inputs,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
{
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.stylix.nixosModules.stylix
      else
        inputs.stylix-stable.nixosModules.stylix
    )
  ];

  config = lib.mkIf config.desktop.themes.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${builtins.head config.desktop.themes.list}.yaml";
      polarity = config.desktop.theme.polarity;
      fonts = {
        monospace = builtins.head config.desktop.fonts.monospace;
        sansSerif = builtins.head config.desktop.fonts.sansSerif;
        serif = builtins.head config.desktop.fonts.serif;
        emoji = builtins.head config.desktop.fonts.emoji;
      };
      autoEnable = false;
      targets = {
        console.enable = true;
      };
    };
  };
}
