{
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
{
  users = {
    mutableUsers = opts.users.mutableUsers or true;
    users = builtins.listToAttrs (
      builtins.map (
        key:
        let
          userData = opts.users.${key};
          realName = userData.name or key;
          cleanValue = builtins.removeAttrs userData [
            "name"
            "home-manager"
            "xdg"
          ];
        in
        {
          name = realName;
          value =
            if realName == "root" then
              cleanValue
            else
              cleanValue
              // {
                shell = pkgs.${userData.shell or "shadow"};
              };
        }
      ) (builtins.attrNames (builtins.removeAttrs opts.users [ "mutableUsers" ]))
    );
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users = builtins.listToAttrs (
      builtins.filter (x: x.value != null) (
        builtins.map
          (
            key:
            let
              isHmEnabled = userData.home-manager or false;
              userData = opts.users.${key};
              realName = userData.name or key;
              uXdg = userData.xdg.userDirs or { };
            in
            if isHmEnabled then
              {
                name = realName;
                value = {
                  home = {
                    username = realName;
                    homeDirectory = "/home/${realName}";
                    stateVersion = mylib.channel.getStateVersion opts;
                    sessionVariables = lib.mkMerge [
                      (lib.optionalAttrs (opts ? editor) { EDITOR = opts.editor; })
                      (lib.optionalAttrs (opts ? terminal) { TERMINAL = opts.terminal; })
                      (lib.optionalAttrs (opts ? browser) { BROWSER = opts.browser; })
                    ];
                  };
                  xdg = {
                    userDirs = {
                      enable = true;
                      createDirectories = false;
                      desktop = uXdg.desktop or "/home/${realName}/dsk";
                      documents = uXdg.documents or "/home/${realName}/doc";
                      download = uXdg.download or "/home/${realName}/dls";
                      music = uXdg.music or "/home/${realName}/mus";
                      pictures = uXdg.pictures or "/home/${realName}/pic";
                      videos = uXdg.videos or "/home/${realName}/vid";
                      templates = uXdg.templates or "/home/${realName}/tpl";
                      publicShare = uXdg.publicShare or "/home/${realName}/pub";
                    };
                  };
                  programs.home-manager.enable = true;
                };
              }
            else
              {
                name = null;
                value = null;
              }
          )
          (
            builtins.attrNames (
              builtins.removeAttrs opts.users [
                "mutableUsers"
                "root"
              ]
            )
          )
      )
    );
  };
  nix.settings.trusted-users = [
    "${opts.users.primary.name}"
    "@wheel"
  ];
}
