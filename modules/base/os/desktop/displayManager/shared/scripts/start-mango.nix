{ pkgs }:
pkgs.writeShellScriptBin "start-mango" ''
  if hash systemctl >/dev/null 2>&1; then
    if systemctl --user -q is-active mango-session.target; then
      echo 'A mango session is already running.'
      exit 1
    fi

    systemctl --user start mango-session.target
    mango "$@" &
    MANGO_PID=$!
    trap 'systemctl --user stop graphical-session.target' EXIT
    wait "$MANGO_PID"
  fi
''
