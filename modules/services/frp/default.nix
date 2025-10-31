{ opts, ... }:
{
  services.frp = {
    enable = true;
    role = opts.frp.role;
    settings = opts.frp.settings;
  };
  systemd.services.frp.serviceConfig = {
    EnvironmentFile = opts.frp.environmentFile;
  };
}
