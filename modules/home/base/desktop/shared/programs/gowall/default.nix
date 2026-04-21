{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  hasThemes = osConfig.desktop.themes.enable;
  hasWallpaper = config.desktop.wallpaper.enable;
  picDir =
    lib.replaceStrings [ "${config.home.homeDirectory}" "$HOME/" ] [ "" "" ]
      config.xdg.userDirs.pictures;
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
  config = lib.mkIf osConfig.desktop.enable {
    home = {
      packages =
        with pkgs;
        [
          gowall
          tesseract
        ]
        ++ lib.optional (hasThemes && hasWallpaper) gowall-autoconvert;
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
  };
}
