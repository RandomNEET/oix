{ config, opts, ... }:
{
  networking = {
    hostName = opts.hostname or config.system.nixos.distroId;
    networkmanager.enable = true;
    firewall = {
      enable = opts.firewall.enable or true;
      allowedTCPPorts = [ ] ++ (opts.firewall.allowedTCPPorts or [ ]);
      allowedUDPPorts = [ ] ++ (opts.firewall.allowedUDPPorts or [ ]);
      trustedInterfaces = [ ] ++ (opts.firewall.trustedInterfaces or [ ]);
    };
  };
}
