{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.desktop.enable {
    programs.rofi = {
      enable = true;
      terminal = "${lib.getExe' pkgs.${config.defaultPrograms.terminal}
        "${config.defaultPrograms.terminal}"
      }";
      plugins = with pkgs; [
        rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
        rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
      ];
      extraConfig = import ./config.nix;
    };
  };
  imports = [ ./themes ];
}
