{ lib, opts, ... }:
{
  imports = lib.optional (lib.hasAttrByPath [ "proxy" "xray" "role" ] opts) ./${opts.proxy.xray.role};
}
