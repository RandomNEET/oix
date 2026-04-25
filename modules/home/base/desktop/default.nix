{
  osConfig,
  lib,
  pkgs,
  mylib,
  ...
}:
{
  imports = mylib.util.scanPaths ./. {
    types = [
      "directory"
      "regular"
    ];
    extension = ".nix";
    exclude = [
      "shared"
      "default.nix"
    ];
    depth = 1;
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
