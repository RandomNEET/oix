{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [
      "directory"
      "regular"
    ];
    extension = ".nix";
    exclude = [ "default.nix" ];
    depth = 1;
  };
}
