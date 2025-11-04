{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ];
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        asciiquarium-transparent
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
