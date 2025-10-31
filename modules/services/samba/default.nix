{ opts, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = opts.samba.settings;
  };
}
