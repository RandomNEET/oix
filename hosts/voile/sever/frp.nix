{
  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "{{.Envs.FRP_SERVER_ADDR}}";
      serverPort = 20000;
      auth.token = "{{.Envs.FRP_TOKEN}}";
      transport.tls.certFile = "/run/secrets/frp/cert";
      transport.tls.keyFile = "/run/secrets/frp/key";
      transport.tls.trustedCaFile = "/run/secrets/frp/ca";
      includes = [ "/run/secrets/frp/proxies" ];
    };
  };
  systemd.services.frp = {
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
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/proxies" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/cert" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/key" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/ca" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
  };
}
