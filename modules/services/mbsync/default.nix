{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      services.mbsync = {
        enable = true;
        verbose = opts.mbsync.verbose or true;
        configFile = opts.mbsync.configFile or null;
        frequency = opts.mbsync.frequency or "*:0/5";
        preExec = opts.mbsync.preExec or null;
        postExec = opts.mbsync.postExec or null;
      };
    })
  ];
}
