{ mylib, ... }:
{
  home.shellAliases = {
    "_" = "sudo ";
    diff = "diff -u --color";
  };

  imports = mylib.util.scanPaths ./. {
    types = [ "regular" ];
    extension = ".nix";
    exclude = [ "default.nix" ];
    depth = 1;
  };
}
