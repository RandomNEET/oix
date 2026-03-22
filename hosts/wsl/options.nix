# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # System {{{
  # Base {{{
  hostname = "wix";
  system = "x86_64-linux"; # x86_64-linux aarch64-linux
  flake = "/home/${users.primary.name}/oix"; # flake path
  channel = "unstable"; # nixpkgs channel; unstable or stable
  # }}}

  # Users {{{
  users = {
    root = {
      initialHashedPassword = "$6$1bNtqKFsObhMC1OG$THnog0HqmR/GnN.0IwndZzuijVMiV0cZIPUjmCvDs6gsjHAc.FYfcIlKmiMx2hy2gbd814Br1uNAhiyKl4W9g.";
    };
    primary = rec {
      # User config
      name = "howl";
      initialHashedPassword = "$6$.FVrKngH1eXjNYi9$lsTAUQvvJyB209fhkf3g5E12iCcgNdDZKW0XTwCp7i3lNwM8gjNq3kRgjW4WIBV68YETysoDCHhKtSIncPT3n1";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = "zsh";
      # Home-manager config
      home-manager = true; # whether to enable home-manager for this user
      xdg = {
        userDirs = {
          desktop = null; # no need for wm
          documents = "/home/${name}/doc";
          download = "/home/${name}/dls";
          music = "/home/${name}/mus";
          pictures = "/home/${name}/pic";
          videos = "/home/${name}/vid";
          templates = "/home/${name}/tpl";
          publicShare = "/home/${name}/pub";
        };
      };
    };
    mutableUsers = false;
  };

  # Define default programs
  editor = "nvim";
  terminalFileManager = "yazi";
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

  # Misc {{{
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  # }}}
  # }}}
}
