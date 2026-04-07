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
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [ "-e" ];
        steamArgs = [
          "-tenfoot"
          "-pipewire-dmabuf"
        ];
      };
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
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
  }; # xbox one
  services.udev.packages = with pkgs; [ game-devices-udev-rules ]; # dualsense edge

  environment.systemPackages = [
    (pkgs.makeDesktopItem {
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
}
