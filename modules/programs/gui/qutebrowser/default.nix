{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs = {
          qutebrowser = {
            enable = true;
            loadAutoconfig = false;
            enableDefaultBindings = false;

            settings = import ./settings.nix { inherit opts; };
            keyBindings = import ./binds.nix { inherit config lib; };
            greasemonkey = import ./greasemonkey.nix { inherit pkgs; };
            searchEngines = import ./search.nix { inherit opts; };
            perDomainSettings = import ./domains.nix { inherit opts; };
            quickmarks = import ./quickmarks.nix { inherit opts; };

            extraConfig = ''
              import themes
            ''
            + lib.optionalString ((opts.theme or "") == "catppuccin-mocha") ''
              themes.catppuccin.setup(c, 'mocha', True, ${toString (opts.qutebrowser.theme.opacity0 or 0.9)}, ${
                toString (opts.qutebrowser.theme.opacity1 or 0.1)
              })
            '';
          };
        };
        home.file = {
          ".config/qutebrowser/userscripts".source = ./userscripts;
          ".config/qutebrowser/themes".source = ./themes;
        };
      }
    )
  ];
}
