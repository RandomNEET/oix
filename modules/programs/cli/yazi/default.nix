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
        theme = import ./theme.nix;
        initLua = builtins.readFile ./init.lua;
      };
      imports = [ ./plugins.nix ];
    })
  ];
}
