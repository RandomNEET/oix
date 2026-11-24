{
  config,
  lib,
  pkgs,
  ...
}:
rec {
  oix = {
    defaults = {
      editor = "nvim";
      fileManager = "yazi";
      terminal = "foot";
      browser = "qutebrowser";
    };
    desktop = {
      wallpaper = {
        dir = "${config.home.homeDirectory}/pic/wallpapers";
      };
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
        zenith = {
          hostname = "zenith.local";
          user = "howl";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/zenith";
          addKeysToAgent = "yes";
        };
        gale = {
          hostname = "gale.local";
          user = "howl";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        gale-ts = {
          hostname = "gale";
          user = "howl";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        voile = {
          hostname = "voile.local";
          user = "howl";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/voile";
          addKeysToAgent = "yes";
        };
        voile-ts = {
          hostname = "voile";
          user = "howl";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/voile";
          addKeysToAgent = "yes";
        };
        voile-agent = {
          hostname = "127.0.0.1";
          port = 2200;
          user = "howl";
          proxyJump = "voile";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/voile";
          HostKeyAlias = "voile-agent";
        };
        voile-agent-ts = {
          hostname = "127.0.0.1";
          port = 2200;
          user = "howl";
          proxyJump = "voile-ts";
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/voile";
          HostKeyAlias = "voile-agent-ts";
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
          ];
        };
      };
    };
    distrobox = {
      containers = {
        debian = {
          image = "docker.io/library/debian:latest";
          home = "${config.home.homeDirectory}/.distrobox/debian";
          pre_init_hooks = [ "sh /run/oix-distrobox-scripts/apt-mirror.sh" ];
          additional_flags = "--log-driver=k8s-file";
        };
      };
    };
    mcp = {
      servers = {
        context7 = {
          command = lib.getExe pkgs.context7-mcp;
          env.CONTEXT7_API_KEY = {
            file = "${config.xdg.configHome}/sops-nix/secrets/mcp/context7";
          };
        };
        github = {
          command = lib.getExe pkgs.github-mcp-server;
          args = [ "stdio" ];
          env.GITHUB_PERSONAL_ACCESS_TOKEN = {
            file = "${config.xdg.configHome}/sops-nix/secrets/mcp/github";
          };
        };
      };
    };
    noctalia = {
      settings = {
        shell = {
          avatar_path = "${config.home.homeDirectory}/pic/avatars/weeb.jpg";
        };
        wallpaper.automation.enabled = lib.mkForce false;
      };
    };
  };
  wayland = {
    windowManager = {
      niri = {
        extraConfig = ''
          include optional=true "${config.xdg.configHome}/niri/outputs.kdl"
        '';
      };
    };
  };
  services = {
    flatpak = {
      packages = [
        "com.github.tchx84.Flatseal"
        "org.localsend.localsend_app"
        "org.qbittorrent.qBittorrent"
      ];
    };
    mbsync = {
      configFile = "${config.xdg.configHome}/sops-nix/secrets/email/mbsync";
      imapnotify.enable = true;
      trigger.enable = true;
    };
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
          imapnotify = {
            enable = true;
            boxes = [
              "Inbox"
              "Inbox/dev"
              "Inbox/contact"
              "Inbox/selfhost"
              "Inbox/bill"
              "Inbox/cert"
              "Inbox/temp"
            ];
            onNotify = "${pkgs.systemd}/bin/systemctl --user start mbsync.service";
          };
        };
      };
    };
  };
  xdg = {
    userDirs = {
      enable = true;
      desktop = null;
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
      "ssh/zenith".sopsFile = ./secrets.yaml;
      "ssh/gale".sopsFile = ./secrets.yaml;
      "ssh/voile".sopsFile = ./secrets.yaml;
      "mcp/context7".sopsFile = ./secrets.yaml;
      "mcp/github".sopsFile = ./secrets.yaml;
      "email/RandomNEET/password".sopsFile = ./secrets.yaml;
      "email/mbsync".sopsFile = ./secrets.yaml;
    };
  };
}
