{ opts, isExt, ... }:
{
  programs.nh = {
    enable = true;
    flake = opts.nh.flake or null;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
  home-manager.sharedModules = [
    {
      programs.nh = {
        enable = isExt;
        osFlake = opts.nh.flake or null;
        homeFlake = opts.nh.flake or null;
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep 5 --keep-since 3d";
        };
      };
    }
  ];
}
