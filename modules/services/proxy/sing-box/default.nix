{ lib, opts, ... }:
{
  imports = lib.optional ((opts.proxy.sing-box.role or "") != "") ./${opts.proxy.sing-box.role};
}
