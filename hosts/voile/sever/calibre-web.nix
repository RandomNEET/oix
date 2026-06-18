{
  services.calibre-web = {
    enable = true;
    openFirewall = true;
    listen = {
      ip = "0.0.0.0";
      port = 10100;
    };
    options = {
      calibreLibrary = "/mnt/smb/media/library";
      enableBookUploading = true;
      enableBookConversion = true;
      enableKepubify = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 10100 ];
  systemd.services.calibre-web = {
    after = [
      "mnt-smb.mount"
    ];
    requires = [
      "mnt-smb.mount"
    ];
  };
}
