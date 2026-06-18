{
  services.speedtest-tracker = {
    enable = true;
    enableNginx = true;
    virtualHost = "speedtest.defnothowl.com";
    settings = {
      APP_KEY_FILE = "/run/secrets/speedtest-tracker";
      APP_URL = "https://speedtest.defnothowl.com";
    };
  };
  services.nginx.virtualHosts."speedtest.defnothowl.com" = {
    forceSSL = false;
    enableACME = false;
    listen = [
      {
        addr = "127.0.0.1";
        port = 10400;
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [ 10400 ];
  systemd.services = {
    speedtest-tracker-scheduler.serviceConfig.Environment = [
      "http_proxy=http://127.0.0.1:9998"
      "https_proxy=http://127.0.0.1:9998"
    ];
    speedtest-tracker-queue-worker.serviceConfig.Environment = [
      "http_proxy=http://127.0.0.1:9998"
      "https_proxy=http://127.0.0.1:9998"
    ];
  };
  sops.secrets.speedtest-tracker = {
    sopsFile = ../secrets.yaml;
    owner = "speedtest-tracker";
  };
}
