{ config, lib, ... }:
let
  username = config.home.username;
in
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
        zenith = {
          hostname = "zenith.local";
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/zenith";
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
      "email/RandomNEET/password".sopsFile = ./secrets.yaml;
      "email/mbsync".sopsFile = ./secrets.yaml;
    };
  };
}
