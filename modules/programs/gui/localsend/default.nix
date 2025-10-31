{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 53317 ];
  home-manager.sharedModules = [ (_: { home.packages = with pkgs; [ localsend ]; }) ];
}
