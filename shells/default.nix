{ pkgs }:
{
  default = (import ./fhs.nix { inherit pkgs; }).env;
  fhs = (import ./fhs.nix { inherit pkgs; }).env;
  c-cpp = import ./c-cpp.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
}
