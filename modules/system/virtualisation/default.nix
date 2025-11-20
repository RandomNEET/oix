{ lib, opts, ... }:
{
  imports =
    lib.optional ((opts.virtualisation.vm.enable or "") != "") ./vm
    ++ lib.optional ((opts.virtualisation.docker.enable or "") != "") ./docker;
}
