{ mylib, ... }: {
  imports = mylib.util.scanPaths ./. { };

  home = {
    preferXdgDirectories = true;
  };
}
