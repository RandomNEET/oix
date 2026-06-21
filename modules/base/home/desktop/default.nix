{
  osConfig,
  lib,
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.util.scanPaths ./. {
    exclude = [
      "shared"
      "default.nix"
    ];
  };

  config = lib.mkIf osConfig.desktop.enable {
    home.packages = with pkgs; [
      ffmpeg
      imagemagick

      lolcat
      figlet
      fortune
      cowsay
      asciiquarium-transparent
      cbonsai
      cmatrix
      pipes
      tty-clock
    ];
  };
}
