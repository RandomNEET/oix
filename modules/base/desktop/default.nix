{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [
      "directory"
      "regular"
    ];
    extension = ".nix";
    exclude = [
      "shared"
      "default.nix"
    ];
    depth = 1;
  };
}
