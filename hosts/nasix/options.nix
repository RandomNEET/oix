# vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # Base {{{
  hostname = "nasix";
  system = "x86_64-linux";
  gpu = "nvidia"; # available: amd nvidia intel-intergrated
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  # }}}

  # Boot {{{
  boot = {
    kernelPackages = "linuxPackages"; # linuxPackages_(latest|zen|lts|hardened|rt|rt_latest)
  };
  # }}}

  # Network {{{
  firewall = {
    enable = true;
    allowedTCPPorts = [
      5900
      6600
      6881
      7102
      8000
      9997
      9998
      9999
      10000
      10090
      10100
      10110
      10120
      10200
      10225
      10230
      10240
      10250
      10300
      10310
      10320
      10330
      10340
      10400
      10500
      61208
    ];
    allowedUDPPorts = [ 6881 ];
  };

  # available cores: dae sing-box xray
  proxy = {
    xray = {
      enable = true;
      role = "client";
      method = "redirect";
      settingsFile = "/home/${users.primary.name}/.vault/proxy/xray/${proxy.xray.role}/${proxy.xray.method}/outsider/docker.json";
    };
  };
  # }}}

  # Server {{{
  systemd.services = {
    xray = {
      after = [
        "docker.service"
      ];
    };
    docker = {
      serviceConfig = {
        Environment = [
          "http_proxy=http://127.0.0.1:9998"
          "https_proxy=http://127.0.0.1:9998"
        ];
      };
    };
    jellyfin = {
      serviceConfig = {
        Environment = [
          "http_proxy=http://127.0.0.1:9998"
          "https_proxy=http://127.0.0.1:9998"
        ];
      };
    };
    mpd = {
      after = [
        "mnt-smb.mount"
      ];
      requires = [
        "mnt-smb.mount"
      ];
    };
    homepage-dashboard = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };

  samba = {
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
        "valid users" = [ "${users.primary.name}" ];
        "read only" = "no";
        "writable" = "yes";
      };
    };
  };

  frp = {
    instances = {
      "outsider" = {
        enable = true;
        role = "client";
        settings = {
          serverAddr = "{{.Envs.FRP_SERVER_ADDR}}";
          serverPort = 20000;
          auth.token = "{{.Envs.FRP_TOKEN}}";
          transport.tls.certFile = "/etc/frp/cert/client.crt";
          transport.tls.keyFile = "/etc/frp/cert/client.key";
          transport.tls.trustedCaFile = "/etc/frp/cert/ca.crt";
          includes = [ "/etc/frp/proxies.toml" ];
        };
        environmentFiles = [ "/home/${users.primary.name}/.vault/env/frp.env" ];
      };
    };
  };

  vaultwarden = {
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 10300;
    };
    environmentFile = "/home/${users.primary.name}/.vault/env/vaultwarden.env";
  };

  calibre-web = {
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
    listen = {
      addr = "0.0.0.0";
      port = 10110;
    };
    baseUrl = "https://freshrss.scaphium.xyz";
    defaultUser = users.primary.name;
    passwordFile = "/var/lib/freshrss/password";
  };

  qbittorrent = {
    webuiPort = 10200;
    torrentingPort = 6881;
  };

  homepage-dashboard = {
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
    environmentFile = "/home/${users.primary.name}/.vault/env/homepage-dashboard.env";
  };

  mpd = {
    dataDir = "/mnt/smb/media/.mpd";
    startWhenNeeded = false;
    settings = {
      music_directory = "/mnt/smb/media/music";
      audio_output = [
        {
          type = "httpd";
          name = "MPD HTTP Stream";
          encoder = "vorbis";
          port = "8000";
          quality = "5.0";
        }
      ];
    };
    outputType = "httpd";
  };
  # }}}

  # Hardware {{{
  hardware = {
    nvidia = {
      prime = {
        nvidiaBusId = "PCI:07:0:0";
        amdgpuBusId = "PCI:01:0:0";
      };
    };
  };
  # }}}

  # User {{{
  users = {
    mutableUsers = false;
    root = {
      initialHashedPassword = "$6$1bNtqKFsObhMC1OG$THnog0HqmR/GnN.0IwndZzuijVMiV0cZIPUjmCvDs6gsjHAc.FYfcIlKmiMx2hy2gbd814Br1uNAhiyKl4W9g.";
    };
    primary = {
      name = "howl";
      initialHashedPassword = "$6$.FVrKngH1eXjNYi9$lsTAUQvvJyB209fhkf3g5E12iCcgNdDZKW0XTwCp7i3lNwM8gjNq3kRgjW4WIBV68YETysoDCHhKtSIncPT3n1";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "docker"
      ];
      shell = "zsh";
    };
  };

  # Define default programs
  editor = "nvim";
  terminalFileManager = "yazi";

  xdg = {
    userDirs = {
      desktop = null; # don't even have a desktop
      documents = "/home/${users.primary.name}/doc";
      download = "/home/${users.primary.name}/dls";
      music = "/home/${users.primary.name}/mus";
      pictures = "/home/${users.primary.name}/pic";
      videos = "/home/${users.primary.name}/vid";
      templates = "/home/${users.primary.name}/tpl";
      publicShare = "/home/${users.primary.name}/pub";
    };
  };
  # }}}

  # Shell {{{
  ssh = {
    keyDir = "/home/${users.primary.name}/.vault/ssh";

    server = {
      enable = true;
      ports = [
        22
      ];
      settings = {
        PasswordAuthentication = false;
      };
      authorizedKeysFiles = [ "${ssh.keyDir}/nasix.pub" ];
    };

    client = {
      matchBlocks = {
        "dix" = {
          hostname = "dix.local";
          port = 22;
          user = "howl";
          identityFile = "${ssh.keyDir}/dix";
          addKeysToAgent = "yes";
        };
        "lix" = {
          hostname = "lix.local";
          port = 22;
          user = "howl";
          identityFile = "${ssh.keyDir}/lix";
          addKeysToAgent = "yes";
        };
      };
    };
  };

  zsh = {
    initContent = [
      (lib.mkOrder 500 ''
        if [[ -z "$TMUX" ]]; then
          local host_name=$(hostname)
          
          local raw_uptime=$(cat /proc/uptime | awk '{print int($1)}')
          local days=$((raw_uptime / 86400))
          local hours=$(( (raw_uptime % 86400) / 3600 ))
          local mins=$(( (raw_uptime % 3600) / 60 ))
          local up_time="''${days}d ''${hours}h ''${mins}m"

          local cpu_cores=$(nproc)
          local load_1=$(awk '{print $1}' /proc/loadavg)
          local usage_pct=$(printf "%.1f" $(( load_1 * 100.0 / cpu_cores )))

          local mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
          local mem_avail=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
          local mem_usage=$(( 100 - (mem_avail * 100 / mem_total) ))

          local disk_root=$(df -h / | awk 'NR==2 {print $5}')
          local disk_smb=$(df -h /mnt/smb | awk 'NR==2 {print $5}')

          local cyan="\e[1;36m"
          local green="\e[1;32m"
          local yellow="\e[1;33m"
          local blue="\e[1;34m"
          local magenta="\e[1;35m"
          local reset="\e[0m"
          local dim="\e[2m"

          echo -e "''${blue}╭──────────────────────────────────────────────────╮''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰒄  Host:''${reset} ''${green}''${host_name}''${reset} (Ryzen 7 5800H)"
          echo -e "''${blue}│''${reset}  ''${cyan}󱎫  Up:''${reset}   ''${yellow}''${up_time}''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰓅  Load:''${reset}  ''${green}''${load_1}''${reset} ''${dim}(Usage: ''${usage_pct}% of ''${cpu_cores} cores)''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰍛  Mem:''${reset}   ''${magenta}''${mem_usage}%''${reset} ''${dim}used''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰋊  Disk:''${reset}  ''${blue}/: ''${disk_root}''${reset} ''${dim}|''${reset} ''${blue}SMB: ''${disk_smb}''${reset}"
          echo -e "''${blue}╰──────────────────────────────────────────────────╯''${reset}"
        fi
      '')
    ];
  };
  # }}}

  # Package {{{
  packages = {
    system = [
      "iptables"
      "xray"
    ];
    home = [
      "mediainfo"
      "flac"
      "lolcat"
      "figlet"
      "fortune"
      "cowsay"
      "asciiquarium-transparent"
      "cbonsai"
      "cmatrix"
      "pipes"
      "tty-clock"
      "qq"
    ];
  };
  # }}}
}
