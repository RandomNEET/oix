{
  lib,
  pkgs,
  opts,
  ...
}:
let
  desktop = opts.desktop or "";
  hasDesktop = desktop != "";
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        inherit (lib) optionalAttrs getExe getExe';
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        colors = config.lib.stylix.colors;
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
            }
            // optionalAttrs hasThemes {
              styleset-name = "stylix";
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
              // optionalAttrs hasDesktop { use-terminal-pinentry = "true"; }
              // optionalAttrs hasDesktop { "x-scheme-handler/http*" = "xdg-open {}"; }
              // optionalAttrs hasDesktop {
                "text/plain" = "${opts.terminal} -e ${opts.editor} {}";
              }
              // optionalAttrs hasDesktop {
                "text/html" = "${opts.browser} {}";
              }
              // optionalAttrs config.programs.swayimg.enable { "image/*" = "swayimg {}"; }
              // optionalAttrs config.programs.zathura.enable { "application/pdf" = "zathura {}"; }
              // optionalAttrs config.programs.thunderbird.enable { "message/rfc822" = "thunderbird"; };
            hooks =
              { }
              // optionalAttrs (config.services.mbsync.enable && (opts.mbsync.service.notify.enable or false)) {
                aerc-shutdown = "${import ../../../services/mbsync/scripts/count.nix { inherit pkgs opts; }}";
              };
          };
          stylesets = lib.mkIf hasThemes {
            stylix = ''
              # Default styles
              *.default=true
              *.normal=true
              default.fg=#${colors.base05}

              # Message types
              error.fg=#${colors.base08}
              warning.fg=#${colors.base09}
              success.fg=#${colors.base0B}

              # Tabs
              tab.fg=#${colors.base03}
              tab.bg=#${colors.base01}
              tab.selected.fg=#${colors.base05}
              tab.selected.bg=#${colors.base00}
              tab.selected.bold=true

              # Border
              border.fg=#${colors.base01}
              border.bold=true

              # Message list
              msglist_unread.bold=true
              msglist_flagged.fg=#${colors.base0A}
              msglist_flagged.bold=true
              msglist_result.fg=#${colors.base0D}
              msglist_result.bold=true
              msglist_*.selected.bold=true
              msglist_*.selected.bg=#${colors.base02}

              # Directory list
              dirlist_*.selected.bold=true
              dirlist_*.selected.bg=#${colors.base02}

              # Status line
              statusline_default.fg=#${colors.base04}
              statusline_default.bg=#${colors.base02}
              statusline_error.bold=true
              statusline_success.bold=true

              # Selector and completion
              selector_focused.bg=#${colors.base02}
              completion_default.selected.bg=#${colors.base02}

              # Viewer section
              [viewer]
              url.fg=#${colors.base0D}
              url.underline=true
              header.bold=true
              signature.dim=true

              # Diff highlighting
              diff_meta.bold=true
              diff_chunk.fg=#${colors.base0D}
              diff_chunk_func.fg=#${colors.base0D}
              diff_chunk_func.bold=true
              diff_add.fg=#${colors.base0B}
              diff_del.fg=#${colors.base08}

              # Quote levels
              quote_*.fg=#${colors.base03}
              quote_1.fg=#${colors.base04}
            '';
          };
        };
      }
    )
  ];
}
