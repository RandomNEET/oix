{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [ "directory" ];
    depth = 1;
  };
}
