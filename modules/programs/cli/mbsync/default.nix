{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.mbsync = {
        enable = true;
        groups = { } // (opts.mbsync.program.groups or { });
      };
    })
  ];
}
