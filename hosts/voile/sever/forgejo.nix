let
  domain = "git.defnothowl.com";
  httpPort = 3000;
  sshPort = 22;
in
{
  services = {
    forgejo = {
      enable = true;
      settings = {
        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}";
          HTTP_PORT = httpPort;
          DISABLE_SSH = false;
          SSH_PORT = sshPort;
        };
        session.COOKIE_SECURE = true;
      };
      database = {
        type = "postgres";
        socket = "/run/postgresql";
        createDatabase = false;
      };
      lfs.enable = true;
      dump = {
        enable = true;
        interval = "daily";
        backupDir = "/var/backup/forgejo";
      };
    };
    postgresql = {
      enable = true;
      ensureDatabases = [ "forgejo" ];
      ensureUsers = [
        {
          name = "forgejo";
          ensureDBOwnership = true;
        }
      ];
    };
    openssh.ports = [ sshPort ];
  };
  networking.firewall.allowedTCPPorts = [ httpPort ];
}
