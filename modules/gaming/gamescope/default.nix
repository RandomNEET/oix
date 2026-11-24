{ mylib, meta, ... }:
{
  imports = [
    (mylib.util.mkModule ./. meta)
    ../shared
  ];
}
