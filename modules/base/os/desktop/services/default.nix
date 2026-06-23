{ mylib, ... }: { imports = mylib.util.scanPaths ./. { types = [ "directory" ]; }; }
