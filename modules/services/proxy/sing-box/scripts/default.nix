{ pkgs, ... }:
{
  environment.systemPackages = map (file: import file { inherit pkgs; }) [
    ./proxy-toggle.nix
  ];
}
