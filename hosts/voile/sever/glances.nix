{
  services.glances = {
    # TEMPFIX: python-jose 3.5.0 is marked insecure (CVE-2026-120459).
    # Re-enable once the locked Glances dependency is fixed.
    # enable = true;
    openFirewall = true;
    port = 61208;
    extraArgs = [ "--webserver" ];
  };
  networking.firewall.allowedTCPPorts = [ 61208 ];
}
