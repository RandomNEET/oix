{ pkgs, ... }:
{
  imports = [ ./options.nix ];

  programs.gamemode.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    # Controller support
    xone.enable = true;
    xpadneo.enable = true;
  };

  services.udev.packages = with pkgs; [ game-devices-udev-rules ];
}
