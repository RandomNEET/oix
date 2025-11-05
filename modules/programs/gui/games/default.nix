{ pkgs, opts, ... }:
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        steamArgs = [ "-tenfoot" ]; # Default: -tenfoot -pipewire-dmabuf
      };
      extraCompatPackages = [ pkgs.proton-ge-bin ]; # Or protonup-qt
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
    # Xbox one controllor support
    xpadneo.enable = true;
    xone.enable = true;
  };

  # Dualsense edge support
  services.udev.packages = with pkgs; [ game-devices-udev-rules ];

  environment.systemPackages = builtins.map (name: pkgs.${name}) (opts.games.packages.system or [ ]);

  home-manager.sharedModules = [
    (_: {
      home.packages = builtins.map (name: pkgs.${name}) (opts.games.packages.home or [ ]);
    })
  ];
}
