{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "invalid users" = [
          "root"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";
        security = "user";
      };
      private = {
        browseable = "yes";
        comment = "Private samba share.";
        path = "/mnt/smb";
        "valid users" = [ "howl" ];
        "read only" = "no";
        "writable" = "yes";
      };
    };
  };
}
