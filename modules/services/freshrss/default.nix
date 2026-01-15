{ opts, ... }:
{
  services = {
    freshrss = {
      enable = true;
      webserver = "nginx";
      virtualHost = "freshrss";

      user = opts.freshrss.user or "freshrss";
      dataDir = opts.freshrss.dataDir or "/var/lib/freshrss";
      baseUrl = opts.freshrss.baseUrl or "";
      authType = opts.freshrss.authType or "form";
      defaultUser = opts.freshrss.defaultUser or "admin";
      passwordFile = opts.freshrss.passwordFile or null;
      extensions = opts.freshrss.extensions or [ ];
      language = opts.freshrss.language or "en";
      pool = opts.freshrss.pool or "freshrss";

      database = {
        type = opts.freshrss.database.type or "sqlite";
        user = opts.freshrss.database.user or "freshrss";
        host = opts.freshrss.database.host or "localhost";
        port = opts.freshrss.database.port or null;
        name = opts.freshrss.database.name or "freshrss";
        passFile = opts.freshrss.database.passFile or "/run/secrets/freshrss";
        tableprefix = opts.freshrss.database.tableprefix or null;
      };
    };
    nginx = {
      virtualHosts."freshrss" = {
        listen = [
          {
            addr = opts.freshrss.listen.addr or "127.0.0.1";
            port = opts.freshrss.listen.port or 80;
          }
        ];
      };
    };
  };
}
