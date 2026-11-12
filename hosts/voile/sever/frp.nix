{ pkgs, ... }:
{
  services = {
    frp = {
      instances = {
        voile = {
          enable = true;
          role = "client";
          settings = {
            serverAddr = "{{.Envs.FRP_SERVER_ADDR}}";
            serverPort = 20000;
            auth.token = "{{.Envs.FRP_TOKEN}}";
            transport = {
              tls = {
                certFile = "/run/secrets/frp/cert";
                keyFile = "/run/secrets/frp/key";
                trustedCaFile = "/run/secrets/frp/ca";
              };
              dialServerTimeout = 90;
              heartbeatInterval = 60;
              heartbeatTimeout = 240;
            };
            # 代理定义含敏感配置 转换后的副本也只存放在运行时目录
            includes = [ "/run/frp-voile/proxies.json" ];
          };
        };
      };
    };
    nginx = {
      enable = true;
      streamConfig = ''
        # 后端地址族必须与还原出的客户端地址一致
        map $proxy_protocol_addr $frp_ssh_backend {
          default 127.0.0.1:22;
          ~: "[::1]:22";
        }

        server {
          # 仅信任本机 frpc 不向公网开放这个入口
          listen 127.0.0.1:2222 proxy_protocol;
          proxy_bind $proxy_protocol_addr transparent;
          proxy_pass $frp_ssh_backend;
          proxy_timeout 1h;
        }
      '';
    };
  };
  systemd.services = {
    frp-voile = {
      requires = [ "nginx.service" ];
      after = [
        "sops-nix.service"
        "nginx.service"
      ];
      # OpenSSH 不支持 PROXY protocol SSH 连接须经 Nginx 还原来源 IP
      preStart = ''
        ${pkgs.python3}/bin/python3 - <<'PY'
        import json, tomllib
        from pathlib import Path
        config = tomllib.loads(Path("/run/secrets/frp/proxies").read_text())
        for proxy in config.get("proxies", []):
            if proxy.get("name") == "ssh":
                proxy["localIP"] = "127.0.0.1"
                proxy["localPort"] = 2222
                proxy.setdefault("transport", {})["proxyProtocolVersion"] = "v2"
        Path("/run/frp-voile/proxies.json").write_text(json.dumps(config))
        PY
      '';
      serviceConfig = {
        RuntimeDirectory = "frp-voile";
        RuntimeDirectoryMode = "0700";
        UMask = "0077";
        SupplementaryGroups = [ "keys" ];
        EnvironmentFile = "/run/secrets/frp/env";
      };
    };
    nginx = {
      requires = [ "frp-ssh-routing.service" ];
      after = [ "frp-ssh-routing.service" ];
      # 透明绑定非本机 IP 需要 CAP_NET_RAW
      serviceConfig = {
        AmbientCapabilities = [ "CAP_NET_RAW" ];
        CapabilityBoundingSet = [ "CAP_NET_RAW" ];
      };
    };
    frp-ssh-routing = {
      description = "Return transparent FRP SSH traffic to Nginx";
      after = [ "network.target" ];
      before = [ "nginx.service" ];
      path = [ pkgs.iproute2 ];
      # sshd 发出的回包必须返回透明代理 不能沿默认路由发往真实客户端
      # 表 123 和优先级 12300 专用于这条回程路由
      script = ''
        ip rule del from 127.0.0.0/8 iif lo table 123 priority 12300 2>/dev/null || true
        ip rule add from 127.0.0.0/8 iif lo table 123 priority 12300
        ip route replace local 0.0.0.0/0 dev lo table 123
        ip -6 rule del from ::1/128 iif lo table 123 priority 12300 2>/dev/null || true
        ip -6 rule add from ::1/128 iif lo table 123 priority 12300
        ip -6 route replace local ::/0 dev lo table 123
      '';
      postStop = ''
        ip rule del from 127.0.0.0/8 iif lo table 123 priority 12300 2>/dev/null || true
        ip route flush table 123
        ip -6 rule del from ::1/128 iif lo table 123 priority 12300 2>/dev/null || true
        ip -6 route flush table 123
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
  sops.secrets = {
    "frp/env" = {
      sopsFile = ../secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/proxies" = {
      sopsFile = ../secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/cert" = {
      sopsFile = ../secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/key" = {
      sopsFile = ../secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/ca" = {
      sopsFile = ../secrets.yaml;
      mode = "0440";
      group = "keys";
    };
  };
}
