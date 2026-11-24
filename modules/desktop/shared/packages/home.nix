{ pkgs, ... }:
{
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
    csakura
    pipes
    tty-clock
  ];
}
