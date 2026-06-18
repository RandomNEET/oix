{
  services.linkding = {
    enable = true;
    openFirewall = true;
    port = 10310;
    environmentFile = "/run/secrets/linkding";
  };
  systemd.services.linkding = {
    after = [
      "sops-nix.service"
    ];
    serviceConfig = {
      Environment = [
        "http_proxy=http://127.0.0.1:9998"
        "https_proxy=http://127.0.0.1:9998"
      ];
    };
  };
  sops.secrets.linkding.sopsFile = ../secrets.yaml;
}
