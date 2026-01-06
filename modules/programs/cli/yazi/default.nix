{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs.yazi = {
        enable = true;
        package = pkgs.yazi.override {
          _7zz = pkgs._7zz-rar;
        };
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = import ./settings.nix { inherit lib opts; };
        keymap = import ./keymap.nix { inherit opts; };
        theme = import ./theme.nix;
        initLua = builtins.readFile ./init.lua;
      };
      imports = [ ./plugins.nix ];
    }
  ];
  nix.settings = {
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };
}
