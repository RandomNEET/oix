{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          color_theme = opts.theme;
        };
      };
      home.file.".config/btop/themes".source = ./themes;
    })
  ];
}
