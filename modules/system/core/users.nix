{
  inputs,
  lib,
  pkgs,
  opts,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  users = {
    mutableUsers = opts.users.mutableUsers or true;
    users =
      let
        renamed = builtins.listToAttrs (
          builtins.map (element: {
            name = opts.users.${element}.name or element;
            value = opts.users.${element};
          }) (builtins.attrNames (builtins.removeAttrs opts.users [ "mutableUsers" ]))
        );
      in
      builtins.mapAttrs (
        name: value:
        if name == "root" then value // { } else value // { shell = pkgs.${value.shell or "shadow"}; }
      ) renamed;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${opts.users.primary.name} = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      home = {
        username = opts.users.primary.name;
        homeDirectory = "/home/${opts.users.primary.name}";
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
          desktop = opts.xdg.userDirs.desktop or "$HOME/dsk";
          documents = opts.xdg.userDirs.documents or "$HOME/doc";
          download = opts.xdg.userDirs.download or "$HOME/dls";
          music = opts.xdg.userDirs.music or "$HOME/mus";
          pictures = opts.xdg.userDirs.pictures or "$HOME/pic";
          publicShare = opts.xdg.userDirs.publicShare or "$HOME/pub";
          templates = opts.xdg.userDirs.templates or "$HOME/tpl";
          videos = opts.xdg.userDirs.videos or "$HOME/vid";
        };
      };
    };
  };
}
