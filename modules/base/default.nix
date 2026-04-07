{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [ "directory" ];
    exclude = [ "optionals" ];
    depth = 1;
  };
}
