{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
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
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
  };
}
