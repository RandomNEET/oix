{
  services.frp = {
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
        includes = [ "/run/secrets/frp/proxies" ];
      };
    };
  };
  systemd.services.frp-voile = {
    after = [
      "sops-nix.service"
    ];
    serviceConfig = {
      SupplementaryGroups = [ "keys" ];
      EnvironmentFile = "/run/secrets/frp/env";
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
