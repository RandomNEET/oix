{ opts, ... }:
{
  services.xray = {
    enable = true;
    settingsFile = opts.xray.settingsFile or null;
  };
}
