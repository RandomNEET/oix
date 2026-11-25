{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  meta,
  ...
}:
{
  config = {
    oix.defaults.fileManager = lib.mkDefault "yazi";
  }
  // {
    programs.yazi = lib.mkMerge [
      (import ./plugins {
        inherit
          osConfig
          config
          lib
          pkgs
          ;
      })
      {
        enable = true;
        package = pkgs.yazi.override {
          _7zz = pkgs._7zz-rar;
        };
        enableBashIntegration = true;
        enableZshIntegration = true;
        shellWrapperName = "y";
        settings = import ./settings.nix { inherit osConfig mylib; };
        keymap = import ./keymap.nix { inherit meta; };
        theme = import ./theme.nix;
        initLua = builtins.readFile ./init.lua; # init.lua for yazi itself
      }
    ];
  }
  // lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
    stylix.targets.yazi.enable = true;
  };
}
