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
        programs.qutebrowser = {
          enable = true;
          loadAutoconfig = false;
          enableDefaultBindings = false;
          settings = import ./settings.nix {
            inherit
              config
              lib
              pkgs
              opts
              ;
          };
          keyBindings = import ./binds.nix { inherit config lib; };
          quickmarks = import ./quickmarks.nix { inherit opts; };
          searchEngines = import ./search.nix { inherit opts; };
          perDomainSettings = import ./domains.nix { inherit opts; };
          greasemonkey = import ./greasemonkey.nix { inherit pkgs opts; };
          extraConfig = "" + (opts.qutebrowser.extraConfig or "");
        };
        imports = [ ./userscripts ];
      }
    )
  ];
}
