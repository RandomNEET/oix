{
  config,
  pkgs,
  opts,
  ...
}:
if config.services.dae.enable then
  pkgs.writeShellScriptBin "proxy-toggle" ''

    SERVICE="dae.service"

    if systemctl is-active --quiet "$SERVICE"; then

        echo "Stopping $SERVICE ..."
        sudo systemctl stop "$SERVICE"
        echo "$SERVICE stopped."
    else
        echo "Starting $SERVICE ..."
        sudo systemctl start "$SERVICE"
        echo "$SERVICE started."
    fi
  ''
else if config.services.xray.enable then
  if opts.xray.method != null && opts.xray.method == "tproxy" then
    pkgs.writeShellScriptBin "proxy-toggle" ''

      SERVICE="xray.service"

      if systemctl is-active --quiet "$SERVICE"; then
          echo "Cleaning iptables and routes ..."
          sudo ip route del local default dev lo table 100
          sudo ip rule del fwmark 1 table 100

          sudo iptables -t mangle -D PREROUTING -j XRAY
          sudo iptables -t mangle -D OUTPUT -j XRAY_SELF
          sudo iptables -t mangle -F XRAY
          sudo iptables -t mangle -F XRAY_SELF
          sudo iptables -t mangle -X XRAY
          sudo iptables -t mangle -X XRAY_SELF

          echo "Stopping $SERVICE ..."
          sudo systemctl stop "$SERVICE"

          echo "$SERVICE stopped and rules cleared."
      else
          echo "Applying iptables and routes ..."
          sudo ip route add local default dev lo table 100
          sudo ip rule add fwmark 1 table 100

          sudo iptables -t mangle -N XRAY
          sudo iptables -t mangle -A XRAY -d 10.0.0.0/8 -j RETURN
          sudo iptables -t mangle -A XRAY -d 100.64.0.0/10 -j RETURN
          sudo iptables -t mangle -A XRAY -d 127.0.0.0/8 -j RETURN
          sudo iptables -t mangle -A XRAY -d 169.254.0.0/16 -j RETURN
          sudo iptables -t mangle -A XRAY -d 172.16.0.0/12 -j RETURN
          sudo iptables -t mangle -A XRAY -d 192.0.0.0/24 -j RETURN
          sudo iptables -t mangle -A XRAY -d 224.0.0.0/4 -j RETURN
          sudo iptables -t mangle -A XRAY -d 240.0.0.0/4 -j RETURN
          sudo iptables -t mangle -A XRAY -d 255.255.255.255/32 -j RETURN
          sudo iptables -t mangle -A XRAY -d 192.168.0.0/16 -p tcp ! --dport 53 -j RETURN
          sudo iptables -t mangle -A XRAY -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
          sudo iptables -t mangle -A XRAY -p tcp -j TPROXY --on-port 52345 --tproxy-mark 1
          sudo iptables -t mangle -A XRAY -p udp -j TPROXY --on-port 52345 --tproxy-mark 1
          sudo iptables -t mangle -A PREROUTING -j XRAY

          sudo iptables -t mangle -N XRAY_SELF
          sudo iptables -t mangle -A XRAY_SELF -d 10.0.0.0/8 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 100.64.0.0/10 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 127.0.0.0/8 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 169.254.0.0/16 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 172.16.0.0/12 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 192.0.0.0/24 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 224.0.0.0/4 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 240.0.0.0/4 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 255.255.255.255/32 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 192.168.0.0/16 -p tcp ! --dport 53 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -d 192.168.0.0/16 -p udp ! --dport 53 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -m mark --mark 2 -j RETURN
          sudo iptables -t mangle -A XRAY_SELF -p tcp -j MARK --set-mark 1
          sudo iptables -t mangle -A XRAY_SELF -p udp -j MARK --set-mark 1
          sudo iptables -t mangle -A OUTPUT -j XRAY_SELF

          echo "Starting $SERVICE ..."
          sudo systemctl start "$SERVICE"

          echo "$SERVICE started and rules applied."
      fi
    ''
  else
    pkgs.writeShellScriptBin "proxy-toggle" ''

      SERVICE="xray.service"

      if systemctl is-active --quiet "$SERVICE"; then
          echo "Stopping $SERVICE ..."
          sudo systemctl stop "$SERVICE"

          echo "$SERVICE stopped."
      else
          echo "Starting $SERVICE ..."
          sudo systemctl start "$SERVICE"

          echo "$SERVICE started."
      fi
    ''
else
  null
