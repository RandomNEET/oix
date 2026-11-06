{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.services.mbsync;
in
{
  options = {
    services.mbsync = {
      imapnotify.enable = mkEnableOption "mbsync synchronization triggered by IMAP notifications.";
      trigger.enable = mkEnableOption "mbsync synchronization triggered by file modifications.";
    };
  };
  config = lib.mkMerge [
    (mkIf cfg.imapnotify.enable {
      services.imapnotify = {
        enable = true;
        path = [ pkgs.coreutils ];
      };
      systemd.user.services.mbsync.Unit.RefuseManualStart = false;
    })
    (mkIf cfg.trigger.enable {
      systemd.user.paths.mbsync-trigger = {
        Unit = {
          Description = "Monitor maildir .trigger file to activate mbsync.service";
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
    })
  ];
}
