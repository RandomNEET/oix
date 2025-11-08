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
          verbose = opts.mbsync.service.verbose or true;
          configFile = opts.mbsync.service.configFile or null;
          frequency = opts.mbsync.service.frequency or "*:0/5";
          preExec = opts.mbsync.service.preExec or null;
          postExec = ''
            ${lib.optionalString (opts.mbsync.service.notify.enable or false) "${mbsync-notify}"}
          ''
          + (opts.mbsync.service.postExec or "");
        };
      }
    )
  ];
}
