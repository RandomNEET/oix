{ lib, opts, ... }:
{
  imports = lib.optional ((opts.theme or "") != "") ./${opts.theme};
}
