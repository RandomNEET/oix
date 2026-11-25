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
  gowallAutoconvert = import ./scripts/gowall-autoconvert.nix {
    inherit
      osConfig
      config
      pkgs
      mylib
      ;
  };
in
{
  imports = [ ./options.nix ];

  home = {
    packages =
      with pkgs;
      [ gowall ]
      ++ lib.optional (
        (osConfig.oix.appearance.themes.enable or false) && config.oix.desktop.wallpaper.enable
      ) gowallAutoconvert;
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
