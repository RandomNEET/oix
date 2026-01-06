{ opts, ... }:
{
  home-manager.sharedModules = [
    {
      programs.mbsync = {
        enable = true;
        groups = { } // (opts.mbsync.program.groups or { });
      };
    }
  ];
}
