{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    webuiPort = 10200;
    torrentingPort = 6881;
  };
  systemd.services.qbittorrent = {
    after = [
      "mnt-smb.mount"
    ];
    requires = [
      "mnt-smb.mount"
    ];
  };
}
