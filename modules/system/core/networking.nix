{ opts, ... }:
{
  networking = {
    hostName = opts.hostname;
    networkmanager.enable = true;
    firewall = {
      enable = opts.firewall.enable or true;
      allowedTCPPorts = opts.firewall.allowedTCPPorts or [ ];
      allowedUDPPorts = opts.firewall.allowedUDPPorts or [ ];
    };
  };
}
