{ lib, opts, ... }:
{
  imports =
    lib.optional ((opts.proxy.dae.enable or "") != "") ./dae
    ++ lib.optional ((opts.proxy.sing-box.enable or "") != "") ./sing-box
    ++ lib.optional ((opts.proxy.xray.enable or "") != "") ./xray;
}
