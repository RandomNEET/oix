{
  inputs,
  lib,
  opts,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users = {
    mutableUsers = false;
    users = {
      root.initialHashedPassword = opts.rootpasswd;
      ${opts.username} = {
        initialHashedPassword = opts.userpasswd;
        uid = opts.uid;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${opts.username} = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      home = {
        username = opts.username;
        homeDirectory = "/home/${opts.username}";
        sessionVariables = lib.mkMerge [
          (lib.optionalAttrs ((opts.editor or "") != "") { EDITOR = opts.editor; })
          (lib.optionalAttrs ((opts.terminal or "") != "") { TERMINAL = opts.terminal; })
          (lib.optionalAttrs ((opts.browser or "") != "") { BROWSER = opts.browser; })
        ];
        stateVersion = "25.05";
      };
      xdg = {
        userDirs = {
          enable = true;
          createDirectories = false;
          desktop = opts.xdg.userDirs.desktop;
          documents = opts.xdg.userDirs.documents;
          download = opts.xdg.userDirs.download;
          music = opts.xdg.userDirs.music;
          pictures = opts.xdg.userDirs.pictures;
          publicShare = opts.xdg.userDirs.publicShare;
          templates = opts.xdg.userDirs.templates;
          videos = opts.xdg.userDirs.videos;
        };
      };
    };
  };
}
