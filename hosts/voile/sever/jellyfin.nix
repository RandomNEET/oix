{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  systemd.services.jellyfin = {
    after = [
      "mnt-smb.mount"
    ];
    requires = [
      "mnt-smb.mount"
    ];
    serviceConfig = {
      Environment = [
        "http_proxy=http://127.0.0.1:9998"
        "https_proxy=http://127.0.0.1:9998"
      ];
    };
  };
}
