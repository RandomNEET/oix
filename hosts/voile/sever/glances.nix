{
  services.glances = {
    enable = true;
    openFirewall = true;
    port = 61208;
    extraArgs = [ "--webserver" ];
  };
  networking.firewall.allowedTCPPorts = [ 61208 ];
}
