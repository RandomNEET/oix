{ opts, ... }:
{
  services.dae = {
    enable = true;
    openFirewall = {
      enable = opts.proxy.dae.openFirewall.enable or false;
      port = opts.proxy.dae.openFirewall.port or 12345;
    };
    configFile = opts.proxy.dae.configFile or null;
  };
  imports = [ ./scripts ];
}
