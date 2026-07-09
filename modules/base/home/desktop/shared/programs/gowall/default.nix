# upscaling requires "programs.nix-ld.libraries = [ pkgs.vulkan-loader ];"
{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  gowall-autoconvert = import ./scripts/gowall-autoconvert.nix {
    inherit
      osConfig
      config
      pkgs
      mylib
      ;
  };
in
{
  home = {
    packages =
      with pkgs;
      [ gowall ]
      ++ lib.optional (
        osConfig.desktop.themes.enable && config.desktop.wallpaper.enable
      ) gowall-autoconvert;
    file = {
      ".config/gowall/config.yml".text = ''
        EnableImagePreviewing: true
        InlineImagePreview: true
        OutputFolder: "${config.xdg.userDirs.pictures}/gowall"
        ${builtins.readFile ./themes.yml}
      '';
    };
  };
}
