{ lib, opts, ... }:
{
  imports = lib.optional ((opts.proxy.core or "") != "") ./${opts.proxy.core};
}
