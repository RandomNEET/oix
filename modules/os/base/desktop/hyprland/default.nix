{ config, lib, ... }:
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/services/udisks2
  ];

  config = lib.mkIf config.desktop.hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
