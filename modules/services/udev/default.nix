{ opts, ... }:
{
  services.udev = {
    enable = true;
    extraRules = "" + (opts.udev.extraRules or "");
  };
}
