{ opts, ... }:
{
  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ opts.users.primary.name ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
      };
    };
  }
  // (opts.snapper or { });
}
