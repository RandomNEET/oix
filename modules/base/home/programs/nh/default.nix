{ meta, ... }:
let
  isHm = meta.platform == "home-manager";
in
{
  programs.nh = {
    enable = isHm;
    osFlake = meta.flake;
    homeFlake = meta.flake;
    clean = {
      enable = isHm;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
