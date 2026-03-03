{ opts, ... }:
{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;

    user = opts.qbittorrent.user or "qbittorrent";
    group = opts.qbittorrent.group or "qbittorrent";

    profileDir = opts.qbittorrent.profileDir or "/var/lib/qBittorrent/";

    webuiPort = opts.qbittorrent.webuiPort or 8080;
    torrentingPort = opts.qbittorrent.torrentingPort or null;

    serverConfig = opts.qbittorrent.serverConfig or { };

    extraArgs = [ ] ++ (opts.qbittorrent.extraArgs or [ ]);
  };
}
