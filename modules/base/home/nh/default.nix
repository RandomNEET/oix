{ osConfig, meta, ... }:
{
  programs.nh = {
    enable = !osConfig.programs.nh.enable;
    osFlake = meta.flake;
    homeFlake = meta.flake;
    clean = {
      enable = !osConfig.programs.nh.clean.enable;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
