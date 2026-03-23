{ mylib, ... }:
{
  imports = mylib.util.scanAndImport ./. (name: type: name != "default.nix" && type == "directory");
}
