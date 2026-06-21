{ mylib, ... }: { imports = mylib.util.scanPaths ./. { types = [ "regular" ]; }; }
