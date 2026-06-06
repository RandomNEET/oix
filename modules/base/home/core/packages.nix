{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-diff
    nvd
  ];
}
