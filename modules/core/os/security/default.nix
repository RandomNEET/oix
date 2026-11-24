{ mylib, ... }: { imports = mylib.util.scanPaths ./. { }; }
