{
  systemd.services.tproxy-routing = {
    enable = true;
    description = "Setup Transparent Proxy Routing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/ip route add local default dev lo table 100";
      ExecStartPost = "/run/current-system/sw/bin/ip rule add fwmark 1 table 100";
      RemainAfterExit = true;
    };
  };
}
