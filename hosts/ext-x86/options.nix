# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # Base {{{
  system = "x86_64-linux"; # x86_64-linux aarch64-linux
  osConfig = {
    programs = {
      htop.enable = false;
    };
  };
  # }}}

  # Home {{{
  home = {
    username = "howl";
    homeDirectory = "/home/howl";
    stateVersion = "26.05";
  };
  # }}}

  # User {{{
  # Define default programs
  editor = "nvim";
  terminalFileManager = "yazi";

  xdg = {
    userDirs = {
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
  # }}}

  # Programs {{{
  nh = {
    flake = "/home/${home.username}/oix"; # flake path
  };
  # }}}

  # Packages {{{
  packages = {
    home = [
      "lolcat"
      "figlet"
      "fortune"
      "cowsay"
      "asciiquarium-transparent"
      "cbonsai"
      "cmatrix"
      "pipes"
      "tty-clock"
    ];
  };
  # }}}
}
