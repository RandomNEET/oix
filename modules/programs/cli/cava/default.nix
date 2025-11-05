{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.cava = {
        enable = true;
        settings = {
          general = {
            framerate = 60;
            sensitivity = 100; # Default
            autosens = 1;
          };
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          color = import ./${opts.theme}.nix;
        };
      };
    })
  ];
}
