{ config, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
in
{
  config = mkMerge [
    (mkIf config.desktop.hyprland.enable {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
    })
  ];
}
