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
      let
        inherit (lib) getExe getExe';
      in
      {
        programs.aerc = {
          enable = true;
          extraBinds = import ./binds.nix;
          extraConfig = {
            general = {
              unsafe-accounts-conf = "true";
              pgp-provider = "auto";
            };
            ui = {
              mouse-enabled = "true";
              border-char-vertical = "│";
              border-char-horizontal = "─";
            };
            filters = {
              "text/plain" = "wrap -w 100 | colorize";
              "text/html" = "! ${getExe pkgs.w3m} -I UTF-8 -T text/html";
              "text/calendar" = "calendar";
              "text/\\*" = "${getExe pkgs.bat} -fP --file-name=\"$AERC_FILENAME\" --style=plain";
              ".headers" = "colorize";
              "message/delivery-status" = "colorize";
              "message/rfc822" = "${getExe pkgs.caeml} | colorize";
              "application/mbox" = "${getExe pkgs.catbox} -c caeml | colorize";
              "application/pdf" = "${getExe' pkgs.poppler-utils "pdftotext"} - -l 10 -nopgbrk -q - | fmt -w 100";
              ".filename,~.*\\.csv" = "column -t --separator=\",\"";
            };
            openers =
              { }
              // lib.optionalAttrs ((opts.desktop or "") == "") { use-terminal-pinentry = "true"; }
              // lib.optionalAttrs ((opts.desktop or "") != "") { "x-scheme-handler/http*" = "xdg-open {}"; }
              // lib.optionalAttrs ((opts.desktop or "") != "" && (opts.editor or "") != "") {
                "text/plain" = "${opts.terminal} -e ${opts.editor} {}";
              }
              // lib.optionalAttrs ((opts.desktop or "") != "" && (opts.browser or "") != "") {
                "text/html" = "${opts.browser} {}";
              }
              // lib.optionalAttrs config.programs.swayimg.enable { "image/*" = "swayimg {}"; }
              // lib.optionalAttrs config.programs.zathura.enable { "application/pdf" = "zathura {}"; }
              // lib.optionalAttrs config.programs.thunderbird.enable { "message/rfc822" = "thunderbird"; };
            hooks =
              { }
              //
                lib.optionalAttrs (config.services.mbsync.enable && (opts.mbsync.service.notify.enable or false))
                  {
                    aerc-shutdown = "${import ../../../services/mbsync/scripts/count.nix { inherit pkgs opts; }}";
                  };
          };
        };
      }
    )
  ];
}
