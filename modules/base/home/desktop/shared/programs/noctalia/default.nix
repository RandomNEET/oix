{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
{
  imports = [ ../satty ];

  config = lib.mkIf osConfig.desktop.enable {
    programs.noctalia =
      let
        services = import ./services.nix { inherit osConfig lib; };
      in
      {
        enable = true;
        # package = pkgs.noctalia;
        settings = {
          shell = import ./shell.nix {
            inherit
              osConfig
              config
              lib
              pkgs
              ;
          };
          bar = import ./bar.nix { inherit osConfig lib; };
          widget = import ./widget.nix { inherit osConfig lib; };
          dock = import ./dock.nix;
          wallpaper = import ./wallpaper.nix {
            inherit
              osConfig
              config
              lib
              mylib
              ;
          };
          theme = import ./theme.nix {
            inherit
              osConfig
              config
              lib
              mylib
              ;
          };
          audio = services.audio;
          battery = services.battery;
          brightness = services.brightness;
          calendar = services.calendar;
          idle = services.idle;
          location = services.location;
          nightlight = services.nightlight;
          notification = services.notification;
          system = services.system;
          weather = services.weather;
          hooks = import ./hooks.nix {
            inherit
              osConfig
              config
              lib
              pkgs
              ;
          };
        }
        // import ./misc.nix;
      };

    home.packages = with pkgs; [ tesseract ];
  };
}
