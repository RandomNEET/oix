{ opts, ... }:
{
  services.dae = {
    enable = true;
    openFirewall = {
      enable = opts.dae.openFirewall.enable or false;
      port = opts.dae.openFirewall.port or 12345;
    };
    configFile = opts.dae.configFile or null;
  };
}
