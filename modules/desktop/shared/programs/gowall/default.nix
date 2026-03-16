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
  convert-wall = import ./scripts/convert-wall.nix { inherit pkgs mylib opts; };
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
          packages = with pkgs; [
            gowall
            tesseract
          ];
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
  # Put outside of home-manager to prevent triggering the service when switching specialisation
  systemd.user = lib.mkIf (hasThemes && hasWallpapers) {
    services.convert-wall = {
      description = "Auto convert wallpaper";
      script = "${convert-wall}";
      serviceConfig = {
        Type = "oneshot";
      };
    };
    timers.convert-wall = {
      description = "Auto convert wallpaper timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "60min";
      };
    };
  };
}
