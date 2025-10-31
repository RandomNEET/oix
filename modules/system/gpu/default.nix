{ lib, opts, ... }:
{
  imports = lib.optional ((opts.gpu or "") != "") ./${opts.gpu};
}
