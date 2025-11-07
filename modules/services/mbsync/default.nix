{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      _:
      let
        mbsync-notify = import ./scripts/notify.nix { inherit pkgs opts; };
      in
      {
        services.mbsync = {
          enable = true;
          verbose = opts.mbsync.verbose or true;
          configFile = opts.mbsync.configFile or null;
          frequency = opts.mbsync.frequency or "*:0/5";
          preExec = opts.mbsync.preExec or null;
          postExec = ''
            ${lib.optionalString (opts.mbsync.notify.enable or false) "${mbsync-notify}"}
          ''
          + (opts.mbsync.postExec or "");
        };
      }
    )
  ];
}
