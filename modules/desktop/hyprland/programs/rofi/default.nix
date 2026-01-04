{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.rofi =
        let
          inherit (lib) getExe;
        in
        {
          enable = true;
          terminal = "${getExe pkgs.${opts.terminal}}";
          plugins = with pkgs; [
            rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
            rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
          ];
          extraConfig = import ./config.nix;
        };
      xdg.configFile."rofi/themes" = {
        source = ./themes;
        recursive = true;
      };
    })
  ];
}
