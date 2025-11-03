rec {
  # System
  hostname = "nasix";
  system = "x86_64-linux";
  gpu = "nvidia";
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  boot = {
    kernelPackages = "linuxPackages"; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
  };
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

  # Users
  users = {
    mutableUsers = false;
    root = {
      initialHashedPassword = "$6$1bNtqKFsObhMC1OG$THnog0HqmR/GnN.0IwndZzuijVMiV0cZIPUjmCvDs6gsjHAc.FYfcIlKmiMx2hy2gbd814Br1uNAhiyKl4W9g.";
    };
    default = {
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

  # User environment
  editor = "nvim";
  terminalFileManager = "yazi";
  xdg = {
    userDirs = {
      desktop = null; # null or "$HOME/dsk"
      documents = "$HOME/doc";
      download = "$HOME/dls";
      music = "$HOME/mus";
      pictures = "$HOME/pic";
      publicShare = "$HOME/pub";
      templates = "$HOME/tpl";
      videos = "$HOME/vid";
    };
  };

  # Services
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
    defaultUser = users.default.name;
    passwordFile = "/var/lib/freshrss/password";
  };

  frp = {
    role = "client"; # client server
    settings = {
      serverAddr = "{{.Envs.FRP_SERVER_ADDR}}";
      serverPort = 20000;
      auth.token = "{{.Envs.FRP_TOKEN}}";
      transport.tls.certFile = "/etc/frp/cert/client.crt";
      transport.tls.keyFile = "/etc/frp/cert/client.key";
      transport.tls.trustedCaFile = "/etc/frp/cert/ca.crt";
      includes = [ "/etc/frp/proxies.toml" ];
    };
    environmentFile = "/home/${users.default.name}/.vault/env/frp.env";
  };

  homepage-dashboard = {
    listenPort = 10000;
    allowedHosts = "homepage.scaphium.xyz";
    settings = {
      layout = [
        {
          "Media" = {
            style = "column";
            columns = 3;
          };
        }
        {
          "Downloads & subscriptions" = {
            style = "column";
            columns = 5;
          };
        }
        {
          "Utilities" = {
            style = "column";
            columns = 5;
          };
        }
        {
          "Games" = {
            style = "row";
            columns = 1;
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
        ];
      }
      {
        "Downloads & subscriptions" = [
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
          {
            "AutoBangumi" = {
              href = "https://autobangumi.scaphium.xyz/";
              icon = "https://autobangumi.scaphium.xyz/images/logo.svg";
            };
          }
          {
            "MoviePilot" = {
              href = "https://moviepilot.scaphium.xyz/";
              icon = "https://moviepilot.scaphium.xyz/favicon.ico";
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
            "linkding" = {
              href = "https://linkding.scaphium.xyz/";
              icon = "linkding";
            };
          }
          {
            "Note-Mark" = {
              href = "https://notemark.scaphium.xyz/";
              icon = "https://notemark.scaphium.xyz/icon.svg";
            };
          }
          {
            "draw.io" = {
              href = "http://{{HOMEPAGE_VAR_ADDR}}:10330/";
              icon = "draw-io";
            };
          }
          {
            "NapcatQQ" = {
              href = "http://{{HOMEPAGE_VAR_ADDR}}:6099/";
              icon = "https://raw.githubusercontent.com/NapNeko/NapCatQQ/refs/heads/main/napcat.webui/public/favicon.ico";
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
                url = "udp://127.0.0.1:10500";
              };
            };
          }
        ];
      }
      {
        "Status" = [
          {
            "Info" = {
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
            "CPU Usage" = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:61208";
                version = 4;
                metric = "cpu";
              };
            };
          }
          {
            "Memory usage" = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:61208";
                version = 4;
                metric = "memory";
              };
            };
          }
          {
            "Network usage" = {
              widget = {
                type = "glances";
                url = "http://127.0.0.1:61208";
                version = 4;
                metric = "network:wlo1";
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
    environmentFile = "/home/${users.default.name}/.vault/env/homepage-dashboard.env";
  };

  mpd = {
    dataDir = "/mnt/smb/media/.mpd";
    musicDirectory = "/mnt/smb/media/music";
    startWhenNeeded = false;
    extraConfig = ''
      audio_output {
          type        "httpd"
          name        "MPD HTTP Stream"
          encoder     "vorbis"
          port        "8000"
          quality     "5.0"
      }
    '';
    outputType = "httpd";
  };

  qbittorrent = {
    webuiPort = 10200;
    torrentingPort = 6881;
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
        "valid users" = [ "${users.default.name}" ];
        "read only" = "no";
        "writable" = "yes";
      };
    };
  };

  ssh = {
    keysDir = "/home/${users.default.name}/.vault/ssh";

    server = {
      enable = true;
      ports = [
        22
      ];
      settings = {
        PasswordAuthentication = false;
      };
      authorizedKeysFiles = [ "${ssh.keysDir}/nasix.pub" ];
    };

    client = {
      matchBlocks = {
        "dix" = {
          hostname = "192.168.0.24";
          port = 22;
          user = "howl";
          identityFile = "${ssh.keysDir}/dix";
          addKeysToAgent = "yes";
        };
        "lix" = {
          hostname = "192.168.0.69";
          port = 22;
          user = "howl";
          identityFile = "${ssh.keysDir}/lix";
          addKeysToAgent = "yes";
        };
      };
      agent.enable = true;
    };
  };

  vaultwarden = {
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 10300;
    };
    environmentFile = "/home/${users.default.name}/.vault/env/vaultwarden.env";
  };

  proxy = {
    xray = {
      role = "client";
      method = "lpf"; # tproxy lpf
      settingsFile = "/home/${users.default.name}/.vault/proxy/xray/client/${proxy.xray.method}/outsider/docker.json";
    };
  };

  # Programs
  nixvim = {
    withNodeJs = false;
    withPerl = false;
    withPython3 = true;
    withRuby = false;

    lsp.enable = false;
    treesitter.enable = false; # Automatically disable noice if set to false
    lint.enable = false;
    conform.enable = true;
    copilot.enable = false;
    noice.enable = false; # Require treesitter
    snack = {
      image.enable = false;
    };
  };

  zsh = {
    initContent = '''';

    envExtra = ''
      export VI_MODE_SET_CURSOR=true
      MODE_INDICATOR="%F{red}<<<%f"
    '';

    shellGlobalAliases = {
      G = "| grep";
    };

    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
      ];
    };
  };
}
