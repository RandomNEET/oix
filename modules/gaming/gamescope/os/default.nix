{
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  display = config.oix.hardware.display.info or [ ];
  primaryDisplay = mylib.display.getPrimary display;
  hasSteam = config.oix.gaming.steam.enable or false;
in
{
  imports = [ ./options.nix ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.etc = lib.optionalAttrs ((config.oix.desktop.ly.enable or false) && hasSteam) {
    "ly/sessions/wayland/steam.desktop".text = ''
      [Desktop Entry]
      Name=steam
      Exec=${pkgs.gamescope}/bin/gamescope --steam -e -- steam -tenfoot -pipewire-dmabuf
      DesktopNames=steam
    '';
  };

  environment.systemPackages = lib.optionals hasSteam [
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
