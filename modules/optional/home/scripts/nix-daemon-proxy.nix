{ pkgs, ... }:
let
  nix-daemon-proxy = pkgs.writeShellScriptBin "nix-daemon-proxy" ''
    set -euo pipefail

    OVERRIDE_DIR="/run/systemd/system/nix-daemon.service.d"
    OVERRIDE_FILE="$OVERRIDE_DIR/override.conf"

    usage() {
      echo "Usage: nix-daemon-proxy <on|off|status> [proxy_url]"
      echo ""
      echo "  on <url>   enable proxy (auto-detects HTTP or SOCKS5 from URL scheme)"
      echo "  off        disable proxy"
      echo "  status     show current status"
      exit 1
    }

    case "''${1:-}" in
    on)
      PROXY="''${2:-}"
      if [ -z "$PROXY" ]; then
        echo "Error: proxy URL is required"
        echo "Usage: nix-daemon-proxy on <url>"
        echo "Examples:"
        echo "  nix-daemon-proxy on http://127.0.0.1:123"
        echo "  nix-daemon-proxy on socks5://127.0.0.1:123"
        exit 1
      fi

      # Detect proxy type from URL scheme
      case "$PROXY" in
        http://*|https://*)
          PROXY_TYPE="http"
          ;;
        socks5://*|socks4://*|socks://*)
          PROXY_TYPE="socks5"
          ;;
        *)
          echo "Error: unsupported proxy URL scheme"
          echo "URL must start with http://, https://, socks5://, or socks4://"
          exit 1
          ;;
      esac

      echo "Enabling $PROXY_TYPE proxy: $PROXY ..."
      sudo mkdir -p "$OVERRIDE_DIR"

      if [ "$PROXY_TYPE" = "http" ]; then
        sudo tee "$OVERRIDE_FILE" >/dev/null <<EOF
    [Service]
    Environment="http_proxy=$PROXY"
    Environment="https_proxy=$PROXY"
    Environment="HTTP_PROXY=$PROXY"
    Environment="HTTPS_PROXY=$PROXY"
    EOF
      else
        # SOCKS5 proxy
        sudo tee "$OVERRIDE_FILE" >/dev/null <<EOF
    [Service]
    Environment="ALL_PROXY=$PROXY"
    Environment="all_proxy=$PROXY"
    EOF
      fi

      sudo systemctl daemon-reload
      sudo systemctl restart nix-daemon
      echo "Proxy enabled ($PROXY_TYPE)"
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
        echo "Proxy is not enabled"
      fi
      ;;

    *)
      usage
      ;;
    esac
  '';
in
{
  home.packages = [ nix-daemon-proxy ];
}
