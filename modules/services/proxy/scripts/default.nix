{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
{
  environment.systemPackages =
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
        ./proxy.nix
      ];
}
