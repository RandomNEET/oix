{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs.rofi = {
        enable = true;
        terminal = "${lib.getExe pkgs.${opts.terminal}}";
        plugins = with pkgs; [
          rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
          rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
        ];
        extraConfig = import ./config.nix;
      };
      imports = [ ./themes ];
    }
  ];
}
