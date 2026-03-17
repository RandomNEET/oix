{ mylib, ... }:
{
  imports = mylib.utils.scanAndImport ./. (name: type: name != "default.nix");
}
