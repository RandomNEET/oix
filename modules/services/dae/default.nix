{ opts, ... }:
{
  services.dae = {
    enable = true;
    configFile = opts.dae.configFile or null;
  };
}
