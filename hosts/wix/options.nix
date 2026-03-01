# vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # Base {{{
  hostname = "wix";
  system = "x86_64-linux";
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  # }}}

  # User {{{
  users = {
    mutableUsers = false;
    root = {
      initialHashedPassword = "$6$1bNtqKFsObhMC1OG$THnog0HqmR/GnN.0IwndZzuijVMiV0cZIPUjmCvDs6gsjHAc.FYfcIlKmiMx2hy2gbd814Br1uNAhiyKl4W9g.";
    };
    primary = {
      name = "howl";
      initialHashedPassword = "$6$.FVrKngH1eXjNYi9$lsTAUQvvJyB209fhkf3g5E12iCcgNdDZKW0XTwCp7i3lNwM8gjNq3kRgjW4WIBV68YETysoDCHhKtSIncPT3n1";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = "zsh";
    };
  };

  # Define default programs
  editor = "nvim";
  terminalFileManager = "yazi";

  xdg = {
    userDirs = {
      desktop = null; # no need for wm
      documents = "/home/${users.primary.name}/doc";
      download = "/home/${users.primary.name}/dls";
      music = "/home/${users.primary.name}/mus";
      pictures = "/home/${users.primary.name}/pic";
      videos = "/home/${users.primary.name}/vid";
      templates = "/home/${users.primary.name}/tpl";
      publicShare = "/home/${users.primary.name}/pub";
    };
  };
  # }}}

  # Package {{{
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
