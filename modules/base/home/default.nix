{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [ "directory" ];
    exclude = [ "default.nix" ];
    depth = 1;
  };
}
