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
        if name == "root" then
          {
            initialHashedPassword = value.initialHashedPassword or null;
            initialPassword = value.initialPassword or null;
          }
        else
          {
            description = value.description or "";
            initialHashedPassword = value.initialHashedPassword or null;
            initialPassword = value.initialPassword or null;
            isNormalUser = value.isNormalUser or false;
            isSystemUser = value.isSystemUser or false;
            uid = value.uid or null;
            extraGroups = value.extraGroups or [ ];
            shell = pkgs.${value.shell or "shadow"};
            linger = value.linger or false;
            expires = value.expires or null;
          }
          // lib.optionalAttrs (value ? group) { group = value.group; }
          // lib.optionalAttrs (value ? createHome) { createHome = value.createHome; }
          // lib.optionalAttrs (value ? homeMode) { homeMode = value.homeMode; }
          // lib.optionalAttrs (value ? home) { home = value.home; }
          // lib.optionalAttrs (value ? useDefaultShell) { useDefaultShell = value.useDefaultShell; }
      ) renamed;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${opts.users.default.name} = {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      home = {
        username = opts.users.default.name;
        homeDirectory = "/home/${opts.users.default.name}";
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
