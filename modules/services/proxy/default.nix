{ lib, opts, ... }:
let
  isDaeEnabled = lib.hasAttrByPath [ "proxy" "dae" "enable" ] opts && opts.proxy.dae.enable;
  isSingboxEnabled =
    lib.hasAttrByPath [ "proxy" "sing-box" "enable" ] opts && opts.proxy.sing-box.enable;
  isXrayEnabled = lib.hasAttrByPath [ "proxy" "xray" "enable" ] opts && opts.proxy.xray.enable;
in
{
  imports =
    lib.optional (isDaeEnabled || isSingboxEnabled || isXrayEnabled) ./scripts
    ++ lib.optional isDaeEnabled ./dae
    ++ lib.optional isSingboxEnabled ./sing-box
    ++ lib.optional isXrayEnabled ./xray;
}
