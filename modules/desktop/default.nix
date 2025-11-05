{ lib, opts, ... }:
{
  imports =
    lib.optional ((opts.desktop or "") != "") ./${opts.desktop}
    ++ lib.optional ((opts.theme or "") != "") ./themes/${opts.theme};
}
