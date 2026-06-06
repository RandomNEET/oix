{ meta, ... }:
{
  programs.nh = {
    enable = true;
    flake = meta.flake;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
