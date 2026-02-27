{ opts, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;

    listenPort = opts.homepage-dashboard.listenPort or 8082;
    allowedHosts = opts.homepage-dashboard.allowedHosts or "localhost:8082,127.0.0.1:8082";

    settings = opts.homepage-dashboard.settings or { };
    services = opts.homepage-dashboard.services or [ ];
    widgets = opts.homepage-dashboard.widgets or [ ];
    bookmarks = opts.homepage-dashboard.bookmarks or [ ];
    environmentFiles = opts.homepage-dashboard.environmentFiles or [ ];

    docker = opts.homepage-dashboard.docker or { };
    kubernetes = opts.homepage-dashboard.kubernetes or { };

    proxmox = opts.homepage-dashboard.proxmox or { };
    customCSS = opts.homepage-dashboard.customCSS or "";
    customJS = opts.homepage-dashboard.customJS or "";
  };
}
