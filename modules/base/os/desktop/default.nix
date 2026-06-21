{ mylib, ... }: {
  imports = mylib.util.scanPaths ./. {
    exclude = [
      "shared"
      "default.nix"
    ];
  };
}
