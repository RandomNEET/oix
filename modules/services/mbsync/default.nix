{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        services.mbsync = {
          enable = true;
          verbose = opts.mbsync.service.verbose or true;
          configFile = opts.mbsync.service.configFile or null;
          frequency = opts.mbsync.service.frequency or "*:0/5";
          preExec = opts.mbsync.service.preExec or null;
          postExec =
            ""
            + lib.optionalString (opts.mbsync.service.notify.enable or false) (
              import ./scripts/notify.nix { inherit pkgs opts; }
            )
            + (opts.mbsync.service.postExec or "");
        };
        # for email clients in sandbox, no need to access systemctl to check mail
        systemd.user.paths.mbsync-trigger = lib.mkIf (opts.mbsync.service.trigger.enable or false) {
          Unit = {
            Description = "Trigger mbsync when .trigger file is touched";
          };
          Path = {
            Unit = "mbsync.service";
            PathChanged = "${config.accounts.email.maildirBasePath}/.trigger";
          };
          Install = {
            WantedBy = [ "paths.target" ];
          };
        };
        systemd.user.services.mbsync = {
          Unit = {
            RefuseManualStart = false;
          };
        };
      }
    )
  ];
}
