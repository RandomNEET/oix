{ pkgs, resurrectDir, ... }:
pkgs.writeShellScript "resurrect-cmd-fix" ''
  TARGET_FILE=''${1:-${resurrectDir}/last}

  sed -i -E \
    -e 's/--cmd (lua [^ ]+)/--cmd "\1"/g' \
    -e 's/--cmd (set [^ ]+)/--cmd "\1"/g' \
    "$TARGET_FILE"

  sed -i -E 's|--cmd (lua [^"]+;[^"]+)|--cmd "\1"|g' "$TARGET_FILE"
''
