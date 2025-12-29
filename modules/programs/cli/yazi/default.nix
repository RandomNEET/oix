{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = import ./settings.nix { inherit lib opts; };
        keymap = import ./keymap.nix { inherit opts; };
        initLua =
          builtins.readFile ./init.lua
          + lib.optionalString (
            ((opts.theme or "") != "") && (builtins.pathExists ./themes/${opts.theme}.lua)
          ) (builtins.readFile ./themes/${opts.theme}.lua);
      }
      //
        lib.optionalAttrs (((opts.theme or "") != "") && (builtins.pathExists ./themes/${opts.theme}.lua))
          {
            theme = import ./themes/${opts.theme}.nix;
          };
      imports = [ ./plugins.nix ];
    })
  ];
}
