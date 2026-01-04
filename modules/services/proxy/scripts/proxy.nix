{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  enabledCores = lib.flatten [
    (lib.optional config.services.dae.enable "dae")
    (lib.optional config.services.sing-box.enable "sing-box")
    (lib.optional config.services.xray.enable "xray")
  ];
  coresStr = lib.concatStringsSep " " enabledCores;

  xrayTProxy =
    config.services.xray.enable
    && ((opts.proxy.xray.role or "") == "client")
    && ((opts.proxy.xray.method or "") == "tproxy");
in
pkgs.writeShellScriptBin "proxy" ''
  # Helper Functions for Xray TProxy
  ${lib.optionalString xrayTProxy ''
    apply_xray_rules() {
        echo "=> Applying Xray TProxy iptables rules..."
        sudo ip route add local default dev lo table 100 || true
        sudo ip rule add fwmark 1 table 100 || true
        sudo iptables -t mangle -N XRAY || true
        for range in 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.0.0.0/24 224.0.0.0/4 240.0.0.0/4 255.255.255.255/32; do
            sudo iptables -t mangle -A XRAY -d "$range" -j RETURN
        done
        sudo iptables -t mangle -A XRAY -d 192.168.0.0/16 -p tcp ! --dport 53 -j RETURN
        sudo iptables -t mangle -A XRAY -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
        sudo iptables -t mangle -A XRAY -p tcp -j TPROXY --on-port 52345 --tproxy-mark 1
        sudo iptables -t mangle -A XRAY -p udp -j TPROXY --on-port 52345 --tproxy-mark 1
        sudo iptables -t mangle -A PREROUTING -j XRAY

        sudo iptables -t mangle -N XRAY_SELF || true
        for range in 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.0.0.0/24 224.0.0.0/4 240.0.0.0/4 255.255.255.255/32; do
            sudo iptables -t mangle -A XRAY_SELF -d "$range" -j RETURN
        done
        sudo iptables -t mangle -A XRAY_SELF -d 192.168.0.0/16 -p tcp ! --dport 53 -j RETURN
        sudo iptables -t mangle -A XRAY_SELF -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
        sudo iptables -t mangle -A XRAY_SELF -m mark --mark 2 -j RETURN
        sudo iptables -t mangle -A XRAY_SELF -p tcp -j MARK --set-mark 1
        sudo iptables -t mangle -A XRAY_SELF -p udp -j MARK --set-mark 1
        sudo iptables -t mangle -A OUTPUT -j XRAY_SELF
    }

    flush_xray_rules() {
        echo "=> Cleaning Xray TProxy iptables rules..."
        sudo iptables -t mangle -D PREROUTING -j XRAY 2>/dev/null || true
        sudo iptables -t mangle -D OUTPUT -j XRAY_SELF 2>/dev/null || true
        sudo iptables -t mangle -F XRAY 2>/dev/null || true
        sudo iptables -t mangle -F XRAY_SELF 2>/dev/null || true
        sudo iptables -t mangle -X XRAY 2>/dev/null || true
        sudo iptables -t mangle -X XRAY_SELF 2>/dev/null || true
        sudo ip rule del fwmark 1 table 100 2>/dev/null || true
        sudo ip route del local default dev lo table 100 2>/dev/null || true
    }
  ''}

  # Argument Validation
  if [ "$#" -ne 2 ]; then
      echo "Usage: proxy <core> <action>"
      echo "Available Cores: ${coresStr}"
      echo "Available Actions: start, stop, restart, toggle"
      exit 1
  fi

  CORE=$1
  ACTION=$2

  case "$CORE" in
    ${lib.optionalString config.services.dae.enable "dae) SERVICE=\"dae.service\" ;;"}
    ${lib.optionalString config.services.sing-box.enable "sing-box) SERVICE=\"sing-box.service\" ;;"}
    ${lib.optionalString config.services.xray.enable "xray) SERVICE=\"xray.service\" ;;"}
    *) echo "Error: Core '$CORE' is not enabled or supported."; exit 1 ;;
  esac

  # Action Execution
  case "$ACTION" in
    start)
      ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && apply_xray_rules''}
      sudo systemctl start "$SERVICE"
      ;;
    stop)
      sudo systemctl stop "$SERVICE"
      ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && flush_xray_rules''}
      ;;
    restart)
      ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && flush_xray_rules''}
      sudo systemctl restart "$SERVICE"
      ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && apply_xray_rules''}
      ;;
    toggle)
      if systemctl is-active --quiet "$SERVICE"; then
          sudo systemctl stop "$SERVICE"
          ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && flush_xray_rules''}
      else
          ${lib.optionalString xrayTProxy ''[[ "$CORE" == "xray" ]] && apply_xray_rules''}
          sudo systemctl start "$SERVICE"
      fi
      ;;
    *) echo "Error: Unknown action '$ACTION'."; exit 1 ;;
  esac

  # Status Output
  echo "------------------------------------------------"
  printf "Service: \033[1;34m%s\033[0m\n" "$SERVICE"

  STATUS_INFO=$(systemctl status "$SERVICE" --no-pager -l)

  if echo "$STATUS_INFO" | grep -q "active (running)"; then
      echo -e "Status:  \033[1;32m● RUNNING\033[0m"
  elif echo "$STATUS_INFO" | grep -q "failed"; then
      echo -e "Status:  \033[1;31m✘ FAILED\033[0m"
  else
      echo -e "Status:  \033[1;33m○ STOPPED\033[0m"
  fi
  echo "------------------------------------------------"
''
