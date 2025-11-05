{
  lib,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.spotify-player = {
        enable = true;
        settings = {
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          theme = opts.theme;
        };
      }
      // lib.optionalAttrs ((opts.theme or "") != "") {
        themes = import ./${opts.theme}.nix;
      };
    })
  ];
}
