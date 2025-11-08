{ opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.mbsync = {
        enable = true;
        extraConfig = "" + (opts.mbsync.program.extraConfig or "");
        groups = { } // (opts.mbsync.program.groups or { });
      };
    })
  ];
}
