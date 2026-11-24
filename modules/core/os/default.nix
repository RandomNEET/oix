{ mylib, meta, ... }:
{
  imports = mylib.util.scanPaths ./. { };
  config.meta = meta;
}
