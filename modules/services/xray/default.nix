{ lib, opts, ... }:
{
  imports = lib.optional ((opts.xray.role or "") != "") ./${opts.xray.role};
}
