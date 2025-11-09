{ opts, ... }:
{
  services.tlp = {
    enable = true;
    settings = { } // (opts.tlp.settings or { });
    extraConfig = '''' + (opts.tlp.extraConfig or "");
  };
}
