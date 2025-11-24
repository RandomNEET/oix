{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      home.packages =
        map
          (
            file:
            import file {
              inherit
                config
                lib
                pkgs
                opts
                ;
            }
          )
          [
            ./launcher.nix
            ./random-wall.nix
          ];
    })
  ];
}
