{ pkgs, ... }:
let
  nix-daemon-proxy = pkgs.writeShellScriptBin "nix-daemon-proxy" ''
    set -euo pipefail

    OVERRIDE_DIR="/run/systemd/system/nix-daemon.service.d"
    OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

    usage() {
      echo "Usage: nix-daemon-proxy <on|off|status> [proxy_url]"
      echo ""
      echo "  on <url>   enable proxy"
      echo "  off        disable proxy"
      echo "  status     show current status"
      exit 1
    }

    case "''${1:-}" in
    on)
      PROXY="''${2:-}"
      if [ -z "$PROXY" ]; then
        echo "Error: proxy URL is required"
        echo "Usage: nix-daemon-proxy on http://127.0.0.1:1234"
        exit 1
      fi
      echo "Enabling proxy: $PROXY ..."
      sudo mkdir -p "$OVERRIDE_DIR"
      sudo tee "$OVERRIDE_FILE" >/dev/null <<EOF
    [Service]
    Environment="http_proxy=$PROXY"
    Environment="https_proxy=$PROXY"
    EOF
      sudo systemctl daemon-reload
      sudo systemctl restart nix-daemon
      echo "Proxy enabled"
      ;;

    off)
      if [ -f "$OVERRIDE_FILE" ]; then
        echo "Disabling proxy..."
        sudo rm -f "$OVERRIDE_FILE"
        sudo systemctl daemon-reload
        sudo systemctl restart nix-daemon
        echo "Proxy disabled"
      else
        echo "Proxy is not enabled, nothing to do"
      fi
      ;;

    status)
      if [ -f "$OVERRIDE_FILE" ]; then
        echo "Proxy status: enabled"
        echo "---"
        cat "$OVERRIDE_FILE"
      else
        echo "Proxy status: disabled"
      fi
      ;;

    *)
      usage
      ;;
    esac
  '';
in
{
  environment.systemPackages = [ nix-daemon-proxy ];
}
