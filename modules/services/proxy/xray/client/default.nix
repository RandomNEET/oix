{ lib, opts, ... }:
{
  imports = lib.optional ((opts.proxy.xray.method or "") != "") ./${opts.proxy.xray.method};
}
