{
  lib,
  pkgs,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];

  wallpaperDir = opts.wallpaper.dir or "";
  hasWallpapers = wallpaperDir != "";
in
{
  home-manager.sharedModules = [
    (_: {
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
            EnableImagePreviewing: true
          '';
        };
      };
    })
  ];
  systemd.user = lib.mkIf (hasThemes && hasWallpapers) {
    services.convert-wall = {
      description = "Auto convert wallpaper";
      script = "${import ./scripts/convert-wall.nix { inherit lib pkgs opts; }}";
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
