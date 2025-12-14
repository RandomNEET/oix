{ opts, ... }:
{
  services.frp.instances = opts.frp.instances or { };
}
