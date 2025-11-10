{ lib, opts, ... }:
{
  imports = lib.optional ((opts.xray.method or "") != "") ./${opts.xray.method};
}
