{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = osConfig.desktop.enable;
in
{
  programs.rbw = {
    enable = true;
    settings.pinentry = if hasDesktop then pkgs.pinentry-qt else pkgs.pinentry-curses;
  };
  home.packages = [
    pkgs.pinentry-all
  ]
  ++ lib.optionals hasDesktop [
    pkgs.rofi-rbw
    pkgs.wtype
  ];
}
