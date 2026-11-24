{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.services.mbsync;
in
{
  imports = [ ./options.nix ];

  config = mkMerge [
    {
      programs.mbsync = {
        enable = true;
      };
      services.mbsync = {
        enable = true;
        postExec =
          ""
          + lib.optionalString (osConfig.oix.desktop.enable or false) (
            import ./scripts/notify.nix { inherit config pkgs; }
          );
      };
    }
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
