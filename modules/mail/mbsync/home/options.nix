{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.services.mbsync = {
    imapnotify.enable = mkEnableOption "automatic mbsync mailbox synchronization on IMAP IDLE events via imapnotify";
    trigger.enable = mkEnableOption "on-demand mbsync mailbox synchronization triggered by changes to the maildir `.trigger` file";
  };
}
