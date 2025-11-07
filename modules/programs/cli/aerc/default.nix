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
          extraBinds = import ./binds.nix { inherit opts; };
          extraAccounts = opts.aerc.extraAccounts or { };
          extraConfig = ''
            [filters]
            text/plain=wrap -w 100 | colorize
            text/html=html | colorize
            text/html=! ${getExe pkgs.w3m} -I UTF-8 -T text/html
            text/calendar=calendar
            text/*=${getExe pkgs.bat} -fP --file-name="$AERC_FILENAME" --style=plain
            .headers=colorize
            message/delivery-status=colorize
            message/rfc822=caeml | colorize
            application/mbox=${getExe pkgs.catbox} -c caeml | colorize
            application/pdf=${getExe' pkgs.poppler-utils "pdftotext"} - -l 10 -nopgbrk -q - | fmt -w 100
            .filename,~.*\.csv=column -t --separator=","

            [openers]
            ${lib.optionalString ((opts.desktop or "") != "") "x-scheme-handler/http* = xdg-open {}"}
            ${lib.optionalString ((opts.editor or "") != "") "text/plain = ${opts.editor} {}"}
            ${lib.optionalString ((opts.browser or "") != "") "text/html = ${opts.browser} {}"}
            ${lib.optionalString config.programs.swayimg.enable "image/* = swayimg {}"}
            ${lib.optionalString config.programs.zathura.enable "application/pdf = zathura {}"}
            message/rfc822 = aerc -o {}

            [ui]
            border-char-vertical="│"
            border-char-horizontal="─"
            styleset-name=${opts.theme}
          ''
          + (opts.aerc.extraConfig or "");
          templates = { } // (opts.aerc.templates or { });
        };
        home.file.".config/aerc/stylesets".source = ./themes;
      }
    )
  ];
}
