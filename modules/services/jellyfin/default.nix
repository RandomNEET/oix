{ pkgs, opts, ... }:
{
  services.jellyfin =
    let
      dataDir = opts.jellyfin.dataDir or "/var/lib/jellyfin";
    in
    {
      enable = true;
      openFirewall = true;

      user = opts.jellyfin.user or "jellyfin";
      group = opts.jellyfin.group or "jellyfin";

      dataDir = dataDir;
      configDir = opts.jellyfin.configDir or "${dataDir}/config";
      logDir = opts.jellyfin.logDir or "${dataDir}/log";
      cacheDir = opts.jellyfin.cacheDir or "/var/cache/jellyfin";
    };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
