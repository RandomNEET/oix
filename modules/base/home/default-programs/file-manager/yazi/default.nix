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
  config = lib.mkIf config.defaultPrograms.fileManager.yazi.enable (
    {
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
    // lib.optionalAttrs osConfig.desktop.themes.enable {
      stylix.targets.yazi.enable = true;
    }
  );
}
