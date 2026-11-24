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
    ./options.nix
    (
      if (meta.channel == "unstable") then
        inputs.stylix.nixosModules.stylix
      else
        inputs.stylix-stable.nixosModules.stylix
    )
  ];

  config = lib.mkIf config.oix.desktop.themes.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${builtins.head config.oix.desktop.themes.list}.yaml";
      polarity = config.oix.desktop.themes.polarity;
      fonts = {
        monospace = builtins.head config.oix.desktop.fonts.monospace;
        sansSerif = builtins.head config.oix.desktop.fonts.sansSerif;
        serif = builtins.head config.oix.desktop.fonts.serif;
        emoji = builtins.head config.oix.desktop.fonts.emoji;
      };
      autoEnable = false;
      targets = {
        console.enable = true;
        gtk.enable = true;
        qt.enable = true;
      };
    };
  };
}
