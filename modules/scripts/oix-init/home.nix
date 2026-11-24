{
  lib,
  pkgs,
  meta,
  ...
}:
lib.mkIf (meta.platform == "home-manager") {
  home.packages = [ (import ./pkg.nix { inherit pkgs meta; }) ];
}
