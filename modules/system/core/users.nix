{
  inputs,
  config,
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
  nix.settings.trusted-users = [
    "${opts.users.primary.name}"
    "@wheel"
  ];
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
        stateVersion = "25.11";
      };
      xdg = {
        userDirs = {
          enable = true;
          createDirectories = false;
          desktop = opts.xdg.userDirs.desktop or "${config.users.users.${opts.users.primary.name}.home}/dsk";
          documents =
            opts.xdg.userDirs.documents or "${config.users.users.${opts.users.primary.name}.home}/doc";
          download =
            opts.xdg.userDirs.download or "${config.users.users.${opts.users.primary.name}.home}/pic";
          music = opts.xdg.userDirs.music or "${config.users.users.${opts.users.primary.name}.home}/mus";
          pictures =
            opts.xdg.userDirs.pictures or "${config.users.users.${opts.users.primary.name}.home}/pic";
          publicShare =
            opts.xdg.userDirs.publicShare or "${config.users.users.${opts.users.primary.name}.home}/pub";
          templates =
            opts.xdg.userDirs.templates or "${config.users.users.${opts.users.primary.name}.home}/tpl";
          videos = opts.xdg.userDirs.videos or "${config.users.users.${opts.users.primary.name}.home}/vid";
        };
      };
    };
  };
}
