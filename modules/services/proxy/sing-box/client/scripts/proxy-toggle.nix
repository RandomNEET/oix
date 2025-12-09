{ pkgs, ... }:
pkgs.writeShellScriptBin "proxy-toggle" ''
  SERVICE="sing-box.service"

  if systemctl is-active --quiet "$SERVICE"; then
      echo "Stopping $SERVICE ..."
      sudo systemctl stop --verbose "$SERVICE"
  else
      echo "Starting $SERVICE ..."
      sudo systemctl start --verbose "$SERVICE"
  fi
''
