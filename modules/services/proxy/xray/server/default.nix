{ opts, ... }:
{
  services.xray = {
    enable = true;
    settingsFile = opts.proxy.xray.settingsFile;
  };
}
