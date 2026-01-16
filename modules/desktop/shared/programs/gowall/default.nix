{
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  wallpaperDir = opts.wallpaper.dir or "";
  hasWallpapers = wallpaperDir != "";
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
            ".config/gowall/schema.yml".text = ''
              schemas:
                - name: "tes"
                  config:
                    ocr:
                      provider: "tesseract"
                      model: "tesseract"
            '';
            ".config/gowall/config.yml".text = ''
              EnableImagePreviewing: false
              OutputFolder: "${picDir}/gowall"
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
