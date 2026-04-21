{ pkgs, meta, ... }:
rec {
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
    terminal = "foot";
    browser = "qutebrowser";
  };
  desktop = {
    wallpaper = {
      enable = true;
      dir = "/home/${meta.username}/pic/wallpapers";
    };
  };

  programs = {
    ssh = {
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/github-RandomNEET";
          addKeysToAgent = "yes";
        };
        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/codeberg-RandomNEET";
          addKeysToAgent = "yes";
        };
        zenith = {
          hostname = "zenith.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/zenith";
          addKeysToAgent = "yes";
        };
        voile = {
          hostname = "voile.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/voile";
          addKeysToAgent = "yes";
        };
      };
    };
    git = {
      settings = {
        user = {
          name = "RandomNEET";
          email = "dev@randomneet.me";
        };
      };
    };
    yazi = {
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [
                "g"
                "d"
              ];
              run = "cd ~/dls";
              desc = "Go ~/dls";
            }
            {
              on = [
                "g"
                "r"
              ];
              run = "cd ~/repo";
              desc = "Go ~/repo";
            }
            {
              on = [
                "g"
                "u"
              ];
              run = "cd /run/media/$USER";
              desc = "Go /run/media/$USER";
            }
          ];
        };
      };
    };
    rbw = {
      settings = {
        base_url = "https://vaultwarden.scaphium.xyz";
        email = "selfhost@randomneet.me";
        lock_timeout = 3600;
      };
    };
    foot = {
      server.enable = true;
    };
    qutebrowser = {
      settings = {
        url = {
          default_page = "https://startpage.randomneet.me/";
          start_pages = "https://startpage.randomneet.me/";
        };
      };
      quickmarks = {
        sp = "https://startpage.randomneet.me/";
        hp = "https://homepage.scaphium.xyz/";
        ld = "https://linkding.scaphium.xyz/";
      };
    };
    obsidian = {
      vaults = {
        default = {
          enable = true;
          target = "doc/notes";
        };
      };
    };
    niri = {
      settings = {
        outputs = {
          "eDP-1" = {
            enable = true;
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.008;
            };
            scale = 1.25;
          };
        };
      };
    };
    noctalia-shell = {
      settings = {
        general = {
          avatarImage = "/home/${meta.username}/pic/avatars/weeb.jpg";
        };
      };
    };
  };
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = [
            "desc:Chimei Innolux Corporation 0x14C9, 1920x1080@60, 0x0, 1.25"
          ];
          extraConfig = ''
            workspace = 1, monitor:desc:Chimei Innolux Corporation 0x14C9, default:true;
          '';
        };
      };
    };
  };
  services = {
    flatpak = {
      packages = [
        "com.github.tchx84.Flatseal"
        "com.qq.QQ"
        "com.tencent.WeChat"
      ];
    };
    mbsync = {
      configFile = "/home/${meta.username}/.config/sops-nix/secrets/mbsync";
      trigger.enable = true;
    };
    mpd = {
      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
      extraConfig = ''
        audio_output {
           type   "pipewire"
           name   "PipeWire Sound Server"
        }
        audio_output {
           type   "fifo"
           name   "my_fifo"
           path   "/tmp/mpd.fifo"
           format "44100:16:2"
        }
        auto_update "yes"
      '';
    };
  };
  systemd = {
    user = {
      services.mbsync = {
        Unit.After = [ "sops-nix.service" ];
      };
    };
  };
  home = {
    packages = with pkgs; [
      ffmpeg
      imagemagick
      md2pdf

      localsend
      qbittorrent
      libreoffice
      tor-browser

      lolcat
      figlet
      fortune
      cowsay
      asciiquarium-transparent
      cbonsai
      cmatrix
      pipes
      tty-clock
    ];
  };

  accounts = {
    email = {
      maildirBasePath = ".mail";
      accounts = {
        RandomNEET = {
          primary = true;
          maildir.path = "/neet";
          address = "neet@randomneet.me";
          userName = "neet@randomneet.me";
          passwordCommand = "cat /home/${meta.username}/.config/sops-nix/secrets/email/RandomNEET/password";
          realName = "RandomNEET";
          gpg = {
            key = "0xBFA119DF465BFBB1";
            signByDefault = true;
            encryptByDefault = false;
          };
          flavor = "migadu.com";
          aerc = {
            enable = true;
            extraAccounts = {
              default = "Inbox";
              folders-sort = "Inbox,Inbox/dev,Inbox/contact,Inbox/selfhost,Inbox/bill,Inbox/cert,Inbox/temp,Archive,Drafts,Sent,Junk,Trash";
              check-mail = "5m";
              check-mail-cmd = "touch /home/${meta.username}/${accounts.email.maildirBasePath}/.trigger && sleep 1";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };
  };
  xdg = {
    userDirs = {
      enable = true;
      desktop = null; # no need for wm
      documents = "/home/${meta.username}/doc";
      download = "/home/${meta.username}/dls";
      music = "/home/${meta.username}/mus";
      pictures = "/home/${meta.username}/pic";
      videos = "/home/${meta.username}/vid";
      templates = "/home/${meta.username}/tpl";
      publicShare = "/home/${meta.username}/pub";
    };
  };

  sops = {
    secrets = {
      "ssh/github-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/codeberg-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/zenith".sopsFile = ./secrets.yaml;
      "ssh/voile".sopsFile = ./secrets.yaml;
      "email/RandomNEET/password".sopsFile = ./secrets.yaml;
      mbsync.sopsFile = ./secrets.yaml;
    };
  };
}
