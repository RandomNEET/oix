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
      imapnotify.enable = mkEnableOption "automatic mbsync mailbox synchronization on IMAP IDLE events via imapnotify";
      trigger.enable = mkEnableOption "on-demand mbsync mailbox synchronization triggered by changes to the maildir `.trigger` file";
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
