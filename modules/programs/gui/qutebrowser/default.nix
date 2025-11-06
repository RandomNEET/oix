{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs = {
        qutebrowser = {
          enable = true;
          loadAutoconfig = false;
          enableDefaultBindings = false;

          keyBindings = import ./binds.nix;
          settings = import ./settings.nix { inherit opts; };
          searchEngines = import ./search.nix { inherit opts; };
          quickmarks = import ./quickmarks.nix { inherit opts; };
          perDomainSettings = import ./domains.nix { inherit opts; };
          greasemonkey = import ./greasemonkey.nix { inherit pkgs; };

          aliases = ({ }) // opts.qutebrowser.aliases or { };
          keyMappings = ({ }) // opts.qutebrowser.keyMappings or { };
          extraConfig = ''
            import themes
          ''
          + lib.optionalString ((opts.theme or "") == "catppuccin-mocha") ''
            themes.catppuccin.setup(c, 'mocha', True, ${toString (opts.qutebrowser.theme.opacity0 or 0.9)}, ${
              toString (opts.qutebrowser.theme.opacity1 or 0.1)
            })
          ''
          + (opts.qutebrowser.extraConfig or "");
        };
      };
      home.file = {
        ".config/qutebrowser/userscripts".source = ./userscripts;
        ".config/qutebrowser/themes".source = ./themes;
      };
    })
  ];
}
