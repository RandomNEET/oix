{ lib, opts, ... }:
{
  imports = lib.optional ((opts.proxy.xray.role or "") != "") ./${opts.proxy.xray.role};
}
