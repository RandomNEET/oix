{ opts, ... }:
{
  services.glances = {
    enable = true;
    openFirewall = true;
    port = opts.glances.port or 61208;
    extraArgs = opts.glances.extraArgs or [ "--webserver" ];
  };
}
