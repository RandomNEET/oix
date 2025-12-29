{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.opencode = {
        enable = true;
        settings = {
          autoshare = false;
          autoupdate = true;
          keybinds = {
            leader = "ctrl+x";
          };
        }
        // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
          theme = "catppuccin";
        };
      };
    })
  ];
}
