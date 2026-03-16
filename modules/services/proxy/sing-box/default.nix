{ lib, opts, ... }:
{
  imports = lib.optional (lib.hasAttrByPath [
    "proxy"
    "sing-box"
    "role"
  ] opts) ./${opts.proxy.sing-box.role};
}
