{ mylib, ... }: {
  imports = mylib.util.scanPaths ./. {
    types = [ "directory" ];
    exclude = [ "shared" ];
  };
}
