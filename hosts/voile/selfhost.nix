{ opts, ... }:
{
  services = {
    calibre-web = {
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
    freshrss = {
      enable = true;
      webserver = "nginx";
      virtualHost = "freshrss";
      baseUrl = "https://freshrss.scaphium.xyz";
      defaultUser = opts.users.primary.name;
      passwordFile = "/run/secrets/freshrss";
    };
    frp = {
      enable = true;
      role = "client";
      settings = {
        serverAddr = "{{.Envs.FRP_SERVER_ADDR}}";
        serverPort = 20000;
        auth.token = "{{.Envs.FRP_TOKEN}}";
        transport.tls.certFile = "/run/secrets/frp/cert";
        transport.tls.keyFile = "/run/secrets/frp/key";
        transport.tls.trustedCaFile = "/run/secrets/frp/ca";
        includes = [ "/run/secrets/frp/proxies" ];
      };
    };
    glances = {
      enable = true;
      openFirewall = true;
      port = 61208;
      extraArgs = [ "--webserver" ];
    };
    homepage-dashboard = {
      enable = true;
      openFirewall = true;
      listenPort = 10000;
      allowedHosts = "homepage.scaphium.xyz";
      settings = {
        layout = [
          {
            "Media" = {
              style = "row";
              columns = 4;
            };
          }
          {
            "Downloads" = {
              style = "column";
              columns = 4;
            };
          }
          {
            "Games" = {
              style = "column";
              columns = 4;
            };
          }
          {
            "Utilities" = {
              style = "column";
              columns = 4;
            };
          }
          {
            "Status" = {
              style = "row";
              columns = 3;
            };
          }
        ];
        useEqualHeights = true;
        cardBlur = "sm"; # sm, "", md, etc...
        background = {
          image = "https://gruvbox-wallpapers.pages.dev/wallpapers/anime/sushi.jpg";
          # blur = "sm"; # sm, "", md, xl...
          saturate = 50;
          brightness = 50;
          opacity = 80;
        };
        headerStyle = "underlined";
        hideVersion = true;
        theme = "dark";
        title = "Homepage";
        language = "en";
        quicklaunch = {
          searchDescriptions = true;
          hideInternetSearch = true;
          showSearchSuggestions = true;
          hideVisitURL = true;
          provider = "duckduckgo";
        };
      };
      services = [
        {
          "Media" = [
            {
              "Jellyfin" = {
                href = "http://{{HOMEPAGE_VAR_ADDR}}:8096/";
                widget = {
                  type = "jellyfin";
                  url = "http://127.0.0.1:8096";
                  key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
                  enableBlocks = true;
                  enableNowPlaying = false;
                  enableUser = true;
                  showEpisodeNumber = true;
                  expandOneStreamToTwoRows = false;
                };
                icon = "jellyfin";
              };
            }
            {
              "Calibre" = {
                href = "https://calibre.scaphium.xyz/";
                widget = {
                  type = "calibreweb";
                  url = "http://127.0.0.1:10100";
                  username = "{{HOMEPAGE_VAR_CALIBRE_USERNAME}}";
                  password = "{{HOMEPAGE_VAR_CALIBRE_PASSWORD}}";
                };
                icon = "calibre";
              };
            }
            {
              "FreshRSS" = {
                href = "https://freshrss.scaphium.xyz/";
                widget = {
                  type = "freshrss";
                  url = "http://127.0.0.1:10110";
                  username = "{{HOMEPAGE_VAR_FRESHRSS_USERNAME}}";
                  password = "{{HOMEPAGE_VAR_FRESHRSS_PASSWORD}}";
                };
                icon = "freshrss";
              };
            }
            {
              "Spotify" = {
                href = "https://myspotify.scaphium.xyz/";
                widget = {
                  type = "yourspotify";
                  url = "https://spotifyapi.scaphium.xyz/";
                  key = "{{HOMEPAGE_VAR_SPOTIFY_KEY}}";
                  interval = "week";
                };
                icon = "spotify";
              };
            }
          ];
        }
        {
          "Downloads" = [
            {
              "qBittorrent" = {
                href = "https://qBittorrent.scaphium.xyz/";
                icon = "qbittorrent";
                widget = {
                  type = "qbittorrent";
                  url = "http://127.0.0.1:10200";
                  username = "{{HOMEPAGE_VAR_QBITTORRENT_USERNAME}}";
                  password = "{{HOMEPAGE_VAR_QBITTORRENT_PASSWORD}}";
                };
              };
            }
            {
              "PeerBanHelper" = {
                href = "https://peerbanhelper.scaphium.xyz/";
                icon = "https://peerbanhelper.scaphium.xyz/favicon.ico";
              };
            }
            {
              "ANI-RSS" = {
                href = "https://anirss.scaphium.xyz/";
                icon = "https://anirss.scaphium.xyz/favicon.ico";
              };
            }
          ];
        }
        {
          "Utilities" = [
            {
              "Vaultwarden" = {
                href = "https://vaultwarden.scaphium.xyz/";
                icon = "bitwarden";
              };
            }
            {
              "Linkding" = {
                href = "https://linkding.scaphium.xyz/";
                icon = "linkding";
              };
            }
            {
              "NapcatQQ" = {
                href = "http://{{HOMEPAGE_VAR_ADDR}}:6099/";
                icon = "https://raw.githubusercontent.com/NapNeko/NapCatQQ/refs/heads/main/packages/napcat-webui-frontend/public/favicon.ico";
              };
            }
          ];
        }
        {
          "Games" = [
            {
              "Minecraft" = {
                icon = "minecraft";
                widget = {
                  type = "minecraft";
                  url = "{{HOMEPAGE_VAR_MINECRAFT_URL}}";
                };
              };
            }
          ];
        }
        {
          "Status" = [
            {
              "Glances" = {
                href = "https://glances.scaphium.xyz/";
                widget = {
                  type = "glances";
                  url = "http://127.0.0.1:61208";
                  version = 4;
                  metric = "info";
                };
              };
            }
            {
              "Speedtest" = {
                href = "https://speedtest.scaphium.xyz/admin/";
                widget = {
                  type = "speedtest";
                  url = "http://127.0.0.1:10400";
                  bitratePrecision = 3;
                };
              };
            }
            {
              "Watchtower" = {
                widget = {
                  type = "watchtower";
                  url = "http://127.0.0.1:10090";
                  key = "{{HOMEPAGE_VAR_WATCHATOWER_KEY}}";
                };
              };
            }
          ];
        }
      ];
      widgets = [
        {
          resources = {
            label = "System";
            cpu = true;
            cputemp = true;
            units = "metric";
            memory = true;
            uptime = true;
          };
        }
        {
          resources = {
            label = "Storage";
            disk = [
              "/"
              "/mnt/smb"
              "/mnt/ssd"
            ];
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
      bookmarks = [
        {
          Dev = [
            {
              Github = [
                {
                  href = "https://github.com/";
                  icon = "github";
                }
              ];
            }
            {
              Copilot = [
                {
                  href = "https://copilot.github.com/";
                  icon = "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/github-copilot-icon.svg";
                }
              ];
            }
          ];
        }
        {
          Social = [
            {
              Reddit = [
                {
                  href = "https://reddit.com/";
                  icon = "reddit";
                }
              ];
            }
            {
              X = [
                {
                  href = "https://twitter.com/";
                  icon = "x";
                }
              ];
            }

          ];
        }
        {
          Watch = [
            {
              YouTube = [
                {
                  href = "https://youtube.com/";
                  icon = "youtube";
                }
              ];
            }
            {
              bilibili = [
                {
                  href = "https://bilibili.com/";
                  icon = "https://bilibili.com/favicon.ico";
                }
              ];
            }
          ];
        }
      ];
      environmentFile = "/run/secrets/homepage-dashboard";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    nginx = {
      virtualHosts."freshrss" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 10110;
          }
        ];
      };
    };
    qbittorrent = {
      enable = true;
      openFirewall = true;
      webuiPort = 10200;
      torrentingPort = 6881;
    };
    samba = {
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
          "valid users" = [ "${opts.users.primary.name}" ];
          "read only" = "no";
          "writable" = "yes";
        };
      };
    };
    vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = 10300;
      };
      environmentFile = "/run/secrets/vaultwarden";
    };
  };
  systemd.services = {
    calibre-web = {
      after = [
        "mnt-smb.mount"
      ];
      requires = [
        "mnt-smb.mount"
      ];
    };
    frp = {
      after = [
        "sops-nix.service"
      ];
      serviceConfig = {
        SupplementaryGroups = [ "keys" ];
        EnvironmentFile = "/run/secrets/frp/env";
      };
    };
    homepage-dashboard = {
      wantedBy = [ "multi-user.target" ];
      after = [
        "sops-nix.service"
        "network-online.target"
      ];
      wants = [ "network-online.target" ];
    };
    jellyfin = {
      after = [
        "mnt-smb.mount"
      ];
      requires = [
        "mnt-smb.mount"
      ];
      serviceConfig = {
        Environment = [
          "http_proxy=http://127.0.0.1:9998"
          "https_proxy=http://127.0.0.1:9998"
        ];
      };
    };
    qbittorrent = {
      after = [
        "mnt-smb.mount"
      ];
      requires = [
        "mnt-smb.mount"
      ];
    };
    vaultwarden = {
      after = [
        "sops-nix.service"
      ];
    };
  };
  sops.secrets = {
    "frp/env" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/proxies" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/cert" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/key" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    "frp/ca" = {
      sopsFile = ./secrets.yaml;
      mode = "0440";
      group = "keys";
    };
    vaultwarden = {
      sopsFile = ./secrets.yaml;
      owner = "vaultwarden";
    };
    freshrss = {
      sopsFile = ./secrets.yaml;
      owner = "freshrss";
    };
    homepage-dashboard.sopsFile = ./secrets.yaml;
  };
}
