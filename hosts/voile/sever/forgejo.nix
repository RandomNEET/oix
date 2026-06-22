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
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtps";
          SMTP_ADDR = "smtp.163.com";
          SMTP_PORT = 465;
        };
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
      secrets = {
        mailer = {
          USER = "/run/secrets/forgejo/mailer/user";
          FROM = "/run/secrets/forgejo/mailer/from";
          PASSWD = "/run/secrets/forgejo/mailer/passwd";
        };
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
  sops.secrets = {
    "forgejo/mailer/user".sopsFile = ../secrets.yaml;
    "forgejo/mailer/from".sopsFile = ../secrets.yaml;
    "forgejo/mailer/passwd".sopsFile = ../secrets.yaml;
  };
}
