{
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
let
  hasThemes = opts ? themes;
  hasWallpapers = lib.hasAttrByPath [ "wallpaper" "dir" ] opts;
  gowall-autoconvert = import ./scripts/gowall-autoconvert.nix { inherit pkgs mylib opts; };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        picDir =
          lib.replaceStrings [ "${config.home.homeDirectory}" "$HOME/" ] [ "" "" ]
            config.xdg.userDirs.pictures;
      in
      {
        home = {
          packages =
            with pkgs;
            [
              gowall
              tesseract
            ]
            ++ lib.optional (hasThemes && hasWallpapers) gowall-autoconvert;
          file = {
            ".config/gowall/config.yml".text = ''
              EnableImagePreviewing: false
              OutputFolder: "${picDir}/gowall"
              ${builtins.readFile ./themes.yml}
            '';
            ".config/gowall/schema.yml".text = ''
              schemas:
                - name: "tes"
                  config:
                    ocr:
                      provider: "tesseract"
                      model: "tesseract"
                      language: "eng+chi_sim"
            '';
          };
        };
      }
    )
  ];
}
