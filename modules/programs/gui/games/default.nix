{
  lib,
  pkgs,
  mylib,
  opts,
  ...
}:
let
  display = opts.display or [ ];
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
    # Xbox one controllor support
    xpadneo.enable = true;
    xone.enable = true;
  };

  # Dualsense edge support
  services.udev.packages = with pkgs; [ game-devices-udev-rules ];

  environment.systemPackages =
    with pkgs;
    [ ] ++ builtins.map (name: builtins.getAttr name pkgs) (opts.packages.games.system or [ ]);

  home-manager.sharedModules = [
    {
      home.packages =
        with pkgs;
        [ ] ++ builtins.map (name: builtins.getAttr name pkgs) (opts.packages.games.home or [ ]);

      home.file.".local/share/applications/steam-gamescope.desktop".text = ''
        [Desktop Entry]
        Name=Steam (Gamescope)
        Comment=Application for managing and playing games on Steam
        Exec=gamescope -e ${
          lib.optionalString (primaryDisplay ? output)
            "-O ${primaryDisplay.output} -W ${toString primaryDisplay.width} -H ${toString primaryDisplay.height}"
        } --adaptive-sync -- steam -tenfoot -pipewire-dmabuf
        Icon=steam
        Terminal=false
        Type=Application
        Categories=Network;FileTransfer;Game;
        Categories=Game;
      '';
    }
  ];
}
