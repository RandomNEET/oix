{ lib, opts, ... }:
let
  isVmEnabled =
    lib.hasAttrByPath [ "virtualisation" "vm" "enable" ] opts && opts.virtualisation.vm.enable;
  isDockerEnabled =
    lib.hasAttrByPath [ "virtualisation" "docker" "enable" ] opts && opts.virtualisation.docker.enable;
  isWaydroidEnabled =
    lib.hasAttrByPath [ "virtualisation" "waydroid" "enable" ] opts
    && opts.virtualisation.waydroid.enable;
in
{
  imports =
    lib.optional isVmEnabled ./vm
    ++ lib.optional isDockerEnabled ./docker
    ++ lib.optional isWaydroidEnabled ./waydroid;
}
