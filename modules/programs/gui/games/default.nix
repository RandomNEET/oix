{
  lib,
  pkgs,
  opts,
  ...
}:
let
  displays = opts.display or [ ];
  primaryDisplay = lib.findFirst (d: d.orientation or "" == "landscape") { } displays;
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
    (_: {
      home.packages =
        with pkgs;
        [ ] ++ builtins.map (name: builtins.getAttr name pkgs) (opts.packages.games.home or [ ]);

      home.file.".local/share/applications/steam-gamescope.desktop".text = ''
        [Desktop Entry]
        Name=Steam (Gamescope)
        Exec=gamescope -e -O ${primaryDisplay.output} -W ${toString primaryDisplay.width} -H ${toString primaryDisplay.height} --adaptive-sync -- steam -tenfoot -pipewire-dmabuf
        Type=Application
        Terminal=false
        Icon=steam
        Categories=Game;
      '';
    })
  ];
}
