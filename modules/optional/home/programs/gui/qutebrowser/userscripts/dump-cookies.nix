{ config, pkgs, ... }:
let
  source = "${config.xdg.dataHome}/qutebrowser/webengine/Cookies?nolock=1";
  defaultOutput = "${config.xdg.userDirs.download}/qutebrowser-cookies";
in
pkgs.writeShellScript "dump-cookies" ''
  OUTPUT_PATH="''${1:-${defaultOutput}}"
  mkdir -p "$(dirname "$OUTPUT_PATH")"
  {
    echo '# Netscape HTTP Cookie File'
    ${pkgs.sqlite}/bin/sqlite3 -separator '	' "file:${source}" "
    SELECT
        host_key,
        IIF(host_key LIKE '.%', 'TRUE', 'FALSE'),
        path,
        IIF(is_secure, 'TRUE', 'FALSE'),
        IIF(expires_utc == 0, 0, expires_utc / 1000000 - 11644473600),
        name,
        value
    FROM cookies;"
  } > "$OUTPUT_PATH"
''
