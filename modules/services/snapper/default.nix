{ opts, ... }:
{
  services.snapper = {
    configs =
      opts.snapper.config or {
        home = {
          SUBVOLUME = "/home";
          ALLOW_USERS = [ opts.username ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
        };
      };
    snapshotInterval = opts.snapper.snapshotInterval or "hourly";
    cleanupInterval = opts.snapper.cleanupInterval or "1d";
  };
}
