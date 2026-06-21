{ lib, pkgs, ... }:
{
  services.rsshub = {
    enable = true;
    openFirewall = true;
    settings = {
      PORT = 10120;
      CHROMIUM_EXECUTABLE_PATH = lib.getExe pkgs.chromium;
      PROXY_URI = "http://127.0.0.1:9998";
      PIXIV_BYPASS_CDN = "1";
      PIXIV_BYPASS_HOSTNAME = "public-api.secure.pixiv.net";
      PIXIV_BYPASS_DOH = "https://1.1.1.1/dns-query";
      PIXIV_IMG_PROXY = "https://i.pixiv.re";
    };
    secretFiles = [
      "/run/secrets/rsshub"
      "/home/howl/.vault/rsshub"
    ];
  };
  systemd.services.rsshub = {
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
  sops.secrets.rsshub.sopsFile = ../secrets.yaml;
}
