# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # System {{{
  system = "x86_64-linux"; # x86_64-linux aarch64-linux
  flake = "/home/${home-manager.home.username}/oix"; # flake path
  channel = "unstable"; # nixpkgs channel; unstable or stable
  # }}}

  # Home {{{
  home-manager = rec {
    home = {
      username = "howl";
      homeDirectory = "/home/howl";
    };
    xdg = {
      userDirs = {
        enable = true;
        desktop = null; # no need for wm
        documents = "${home.homeDirectory}/doc";
        download = "${home.homeDirectory}/dls";
        music = "${home.homeDirectory}/mus";
        pictures = "${home.homeDirectory}/pic";
        videos = "${home.homeDirectory}/vid";
        templates = "${home.homeDirectory}/tpl";
        publicShare = "${home.homeDirectory}/pub";
      };
    };
  };

  # Define default programs
  editor = "nvim";
  fileManager = "yazi";
  # }}}

  # Packages {{{
  packages =
    pkgs: with pkgs; {
      home = [
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
  # }}}
}
