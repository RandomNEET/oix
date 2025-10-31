{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        cbonsai
        cowsay
        cmatrix
        fortune
        figlet
        lolcat
        pipes
        tty-clock
      ];
    })
  ];
}
