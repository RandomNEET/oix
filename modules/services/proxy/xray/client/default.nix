{ lib, opts, ... }:
{
  imports = lib.optional (lib.hasAttrByPath [
    "proxy"
    "xray"
    "method"
  ] opts) ./${opts.proxy.xray.method};
}
