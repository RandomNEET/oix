{
  pkgs,
  mylib,
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
        settings = import ./settings.nix { inherit mylib opts; };
        keymap = import ./keymap.nix { inherit opts; };
        theme = import ./theme.nix;
        initLua = builtins.readFile ./init.lua; # init.lua for yazi itself
      };
      imports = [ ./plugins ];
    }
  ];
  nix.settings = {
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };
}
