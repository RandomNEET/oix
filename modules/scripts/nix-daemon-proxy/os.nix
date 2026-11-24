{ pkgs, ... }:
{
  environment.systemPackages = [ (import ./pkg.nix { inherit pkgs; }) ];
}
