{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [ "regular" ];
    extension = ".nix";
    exclude = [ "default.nix" ];
    depth = 1;
  };
}
