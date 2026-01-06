{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 53317 ];
  home-manager.sharedModules = [ { home.packages = with pkgs; [ localsend ]; } ];
}
