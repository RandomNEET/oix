{ config, pkgs, ... }:
let
  username = config.home.username;
in
rec {
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
    terminal = "kitty";
    browser = "qutebrowser";
  };
  desktop = {
    wallpaper = {
      enable = true;
      dir = "${config.home.homeDirectory}/pic/wallpapers";
    };
  };

  programs = {
    ssh = {
      settings = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/github-RandomNEET";
          addKeysToAgent = "yes";
        };
        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/codeberg-RandomNEET";
          addKeysToAgent = "yes";
        };
        "git.defnothowl.com" = {
          hostname = "git.defnothowl.com";
          user = "forgejo";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/defnothowl-howl";
          addKeysToAgent = "yes";
        };
        gale = {
          hostname = "gale.local";
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        voile = {
          hostname = "voile.local";
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/voile";
          addKeysToAgent = "yes";
        };
      };
    };
    git = {
      settings = {
        user = {
          name = "RandomNEET";
          email = "dev@randomneet.me";
          signingkey = "0xBFA119DF465BFBB1";
        };
        commit.gpgsign = true;
        tag.gpgSign = true;
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
    qutebrowser = {
      settings = {
        url = {
          default_page = "https://startpage.randomneet.me/";
          start_pages = "https://startpage.randomneet.me/";
        };
      };
      quickmarks = {
        sp = "https://startpage.randomneet.me/";
        hp = "https://homepage.defnothowl.com/";
        ld = "https://linkding.defnothowl.com/";
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
    noctalia = {
      settings = {
        shell = {
          avatar_path = "${config.home.homeDirectory}/pic/avatars/weeb.jpg";
        };
      };
    };
  };
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = [
            {
              output = "desc:SAC G7u Pro 0001";
              mode = "3840x2160@160";
              position = "0x0";
              scale = 1.5;
            }
            {
              output = "desc:KOS KOIOS K2718UD 0000000000000";
              mode = "3840x2160@60";
              position = "2560x-600";
              scale = 1.5;
              transform = 1;
            }
          ];
          workspace_rule = [
            {
              workspace = "1";
              monitor = "desc:SAC G7u Pro 0001";
              default = true;
            }
            {
              workspace = "10";
              monitor = "desc:KOS KOIOS K2718UD 0000000000000";
              default = true;
            }
          ];
        };
      };
      niri = {
        settings = {
          _children = [
            {
              output._args = [ "DP-1" ];
              output.mode = "3840x2160@144";
              output.scale = 1.5;
              output.position._props = {
                x = 0;
                y = 0;
              };
              output.variable-refresh-rate._props = {
                on-demand = true;
              };
              output.focus-at-startup = { };
            }
            {
              output._args = [ "HDMI-A-1" ];
              output.mode = "3840x2160@60";
              output.scale = 1.5;
              output.transform = "90";
              output.position._props = {
                x = 2560;
                y = -600;
              };
            }
          ];
        };
      };
    };
  };
  services = {
    flatpak = {
      packages = [
        "com.github.tchx84.Flatseal"
        "com.cherry_ai.CherryStudio"
        "org.localsend.localsend_app"
        "org.qbittorrent.qBittorrent"
        "org.libreoffice.LibreOffice"
        "org.torproject.torbrowser-launcher"
        "com.qq.QQ"
        "com.tencent.WeChat"
      ];
    };
    mbsync = {
      configFile = "${config.xdg.configHome}/sops-nix/secrets/email/mbsync";
      trigger.enable = true;
    };
    mpd = {
      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
      dataDir = "/mnt/hdd1/media/.mpd";
      musicDirectory = "/mnt/hdd1/media/music";
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
      osu-lazer
      prismlauncher
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
          passwordCommand = "cat ${config.xdg.configHome}/sops-nix/secrets/email/RandomNEET/password";
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
              check-mail-cmd = "touch ${config.home.homeDirectory}/${accounts.email.maildirBasePath}/.trigger && sleep 1";
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
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/dls";
      music = "${config.home.homeDirectory}/mus";
      pictures = "${config.home.homeDirectory}/pic";
      videos = "${config.home.homeDirectory}/vid";
      templates = "${config.home.homeDirectory}/tpl";
      publicShare = "${config.home.homeDirectory}/pub";
    };
  };

  sops = {
    secrets = {
      "ssh/github-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/codeberg-RandomNEET".sopsFile = ./secrets.yaml;
      "ssh/defnothowl-howl".sopsFile = ./secrets.yaml;
      "ssh/gale".sopsFile = ./secrets.yaml;
      "ssh/voile".sopsFile = ./secrets.yaml;
      "email/RandomNEET/password".sopsFile = ./secrets.yaml;
      "email/mbsync".sopsFile = ./secrets.yaml;
    };
  };
}
