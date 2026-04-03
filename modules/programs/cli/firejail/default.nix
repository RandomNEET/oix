{
  programs.firejail = {
    enable = true;
  };
  home-manager.sharedModules = [ { imports = [ ./warp.nix ]; } ];
}
