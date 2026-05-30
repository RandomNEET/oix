{
  services.homepage-dashboard = {
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
  systemd.services.homepage-dashboard = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "sops-nix.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
  };
  sops.secrets.homepage-dashboard.sopsFile = ./secrets.yaml;
}
