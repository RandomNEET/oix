{ opts, ... }:
{
  home-manager.sharedModules = [
    {
      services.mpd = {
        enable = true;
      }
      // (opts.mpd or { });
    }
  ];
}
