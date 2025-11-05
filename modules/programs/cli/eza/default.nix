{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        icons = "auto";
      }
      // lib.optionalAttrs ((opts.theme or "") != "") {
        theme = opts.theme;
      };
    })
  ];
}
