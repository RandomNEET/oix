{ lib, opts, ... }:
{
  imports = [ ./themes ] ++ lib.optional ((opts.desktop or "") != "") ./${opts.desktop};
}
