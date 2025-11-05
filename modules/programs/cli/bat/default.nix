{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.bat = {
        enable = true;
        config = {
          style = "plain";
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          theme = opts.theme;
        };
      }
      // lib.optionalAttrs ((opts.theme or "") != "") {
        themes = import ./${opts.theme}.nix { inherit pkgs; };
      };
    })
  ];
}
