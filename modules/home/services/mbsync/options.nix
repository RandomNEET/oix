{ config, lib, ... }:
let
  cfg = config.services.mbsync.trigger;
in
{
  options = {
    services.mbsync.trigger.enable = lib.mkEnableOption "mbsync synchronization triggered by file modifications.";
  };
  config = lib.mkIf cfg.enable {
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
  };
}
