{ pkgs, meta, ... }:
{
  environment.systemPackages = [ (import ./pkg.nix { inherit pkgs meta; }) ];
}
