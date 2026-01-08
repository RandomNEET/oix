{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  homeConfig = config.home-manager.users.${opts.users.primary.name};
  profiles = import ./profiles {
    config = homeConfig;
    inherit lib pkgs opts;
  };
in
{
  programs.firejail = {
    enable = true;
  };
  home-manager.sharedModules = [ { imports = [ ./warp.nix ]; } ];
}
