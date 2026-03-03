{ opts, ... }:
{
  services.vaultwarden = {
    enable = true;

    config =
      opts.vaultwarden.config or {
        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
      };
    dbBackend = opts.vaultwarden.dbBackend or "sqlite";
    backupDir = opts.vaultwarden.backupDir or "/var/backup/vaultwarden";
    environmentFile = opts.vaultwarden.environmentFile or "/var/lib/vaultwarden.env";
  };
}
