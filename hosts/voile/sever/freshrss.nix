{
  services = {
    freshrss = {
      enable = true;
      webserver = "nginx";
      virtualHost = "freshrss";
      baseUrl = "https://freshrss.defnothowl.com";
      defaultUser = "howl";
      passwordFile = "/run/secrets/freshrss";
    };
    nginx = {
      virtualHosts."freshrss" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 10110;
          }
        ];
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 10110 ];
  systemd.services.freshrss-updater = {
    serviceConfig = {
      Environment = [
        "http_proxy=http://127.0.0.1:9998"
        "https_proxy=http://127.0.0.1:9998"
      ];
    };
  };
  sops.secrets.freshrss = {
    sopsFile = ../secrets.yaml;
    owner = "freshrss";
  };
}
