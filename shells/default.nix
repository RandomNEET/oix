{ pkgs }:
{
  default = (import ./fhs.nix { inherit pkgs; }).env;
  fhs = (import ./fhs.nix { inherit pkgs; }).env;
  c = import ./c.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
}
