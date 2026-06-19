{
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  display = config.base.display.info;
  primaryDisplay = mylib.display.getPrimary display;
in
{
  imports = [ ./options.nix ];
  config = lib.mkIf config.base.gaming.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode.enable = true;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    # Controllor support
    hardware = {
      xone.enable = true;
      xpadneo.enable = true;
    };
    services.udev.packages = with pkgs; [ game-devices-udev-rules ];

    environment.systemPackages = with pkgs; [
      protonplus

      (makeDesktopItem {
        name = "steam-gamescope";
        desktopName = "Steam (Gamescope)";
        comment = "Application for managing and playing games on Steam";
        exec = "gamescope -e ${
          lib.optionalString (primaryDisplay ? output)
            "-O ${primaryDisplay.output} -W ${toString primaryDisplay.width} -H ${toString primaryDisplay.height}"
        } --adaptive-sync -- steam -tenfoot -pipewire-dmabuf";
        icon = "steam";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "FileTransfer"
          "Game"
        ];
      })
    ];
  };
}
