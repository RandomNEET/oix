{ opts, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings =
      opts.samba.settings or {
        global = {
          "invalid users" = [
            "root"
          ];
          "passwd program" = "/run/wrappers/bin/passwd %u";
          security = "user";
        };
      };
  };
}
