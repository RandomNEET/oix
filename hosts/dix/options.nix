# vim:fileencoding=utf-8:foldmethod=marker
{
  inputs,
  outputs,
  lib,
  ...
}:
{
  opts = rec {
    # System {{{
    hostname = "dix";
    system = "x86_64-linux";
    gpu = "nvidia";
    locale = "en_US.UTF-8";
    timezone = "Asia/Shanghai";
    kbdLayout = "us";
    consoleKeymap = "us";
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
        ];
        shell = "zsh";
      };
    };

    editor = "nvim";
    terminal = "kitty";
    terminalFileManager = "yazi";
    browser = "qutebrowser";

    xdg = {
      userDirs = {
        desktop = null;
        documents = "$HOME/doc";
        download = "$HOME/dls";
        music = "$HOME/mus";
        pictures = "$HOME/pic";
        publicShare = "$HOME/pub";
        templates = "$HOME/tpl";
        videos = "$HOME/vid";
      };
    };
    # }}}

    # Boot {{{
    boot = {
      kernelPackages = "linuxPackages";
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/nix/persist/var/lib/sbctl";
    };
    # }}}

    # Network {{{
    ip = {
      local = "192.168.0.24";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };

    ssh = {
      keysDir = "/home/${users.primary.name}/.vault/ssh";

      server = {
        enable = true;
        ports = [
          22
        ];
        settings = {
          PasswordAuthentication = false;
        };
        authorizedKeysFiles = [ "${ssh.keysDir}/dix.pub" ];
      };

      client = {
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "${ssh.keysDir}/gh-randomneet";
            addKeysToAgent = "yes";
          };
          "lix" = {
            hostname = outputs.nixosConfigurations.lix._module.specialArgs.opts.ip.local;
            port = 22;
            user = "howl";
            identityFile = "${ssh.keysDir}/lix";
            addKeysToAgent = "yes";
          };
          "nasix" = {
            hostname = outputs.nixosConfigurations.nasix._module.specialArgs.opts.ip.local;
            port = 22;
            user = "howl";
            identityFile = "${ssh.keysDir}/nasix";
            addKeysToAgent = "yes";
          };
        };
        agent.enable = false;
      };
    };

    proxy = {
      dae = {
        configFile = "/home/${users.primary.name}/.vault/proxy/dae/default.dae";
        openFirewall = {
          enable = true;
          port = 12345;
        };
      };
    };
    # }}}

    # Security {{{
    gpg = {
      homedir = "/home/${users.primary.name}/.gnupg";
      agent = {
        enable = true;
        enableSshSupport = true;
      };
    };

    rbw = {
      settings = {
        base_url = "https://vaultwarden.scaphium.xyz";
        email = "selfhost@randomneet.me";
        lock_timeout = 3600;
      };
      rofi-rbw = true;
    };
    # }}}

    # Shell {{{
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
        theme = "simple";
      };
    };
    # }}}

    # Editor {{{
    nixvim = {
      withNodeJs = false;
      withPerl = false;
      withPython3 = true;
      withRuby = false;

      treesitter.enable = true;
      lsp.enable = true;
      conform.enable = true;
      lint.enable = true;

      snack = {
        image.enable = true;
      };
      noice.enable = true;

      copilot = {
        enable = true;
        cmp = false;
      };

      obsidian = {
        workspaces = [
          {
            name = "index";
            path = "~/${obsidian.vaults.default.target}/00 index";
            overrides = {
              notes_subdir = "00 index";
            };
          }
          {
            name = "study";
            path = "~/${obsidian.vaults.default.target}/10 study";
            overrides = {
              notes_subdir = "10 study";
            };
          }
          {
            name = "develop";
            path = "~/${obsidian.vaults.default.target}/20 develop";
            overrides = {
              notes_subdir = "20 develop";
            };
          }
          {
            name = "daily";
            path = "~/${obsidian.vaults.default.target}/30 daily";
            overrides = {
              notes_subdir = "30 daily";
            };
          }
          {
            name = "todos";
            path = "~/${obsidian.vaults.default.target}/99 todos";
            overrides = {
              notes_subdir = "99 todos";
            };
          }
        ];
      };
    };
    # }}}

    # Browser {{{
    firefox = {
      network.trr = {
        mode = 3;
        uri = "https://dns.alidns.com/dns-query";
        custom_uri = "https://dns.alidns.com/dns-query";
      };
      browser.startup.homepage = "https://startpage.randomneet.me/";
      DisableFirefoxAccounts = false;
      titlebar-buttons-disable = true;
      full-screen-api.ignore-widgets = true;
    };

    qutebrowser = {
      theme = {
        opacity0 = 0.9;
        opacity1 = 0.1;
      };
      window = {
        hide_decoration = true;
        transparent = true;
      };
      completion = {
        height = "30%";
        shrink = true;
      };
      url = {
        default_page = "https://startpage.randomneet.me/";
        start_pages = "https://startpage.randomneet.me/";
      };
      quickmarks = {
        sp = "https://startpage.randomneet.me/";
        hp = "https://homepage.scaphium.xyz/";
        ld = "https://linkding.scaphium.xyz/";
        mgd = "https://webmail.migadu.com/";
      };
    };
    # }}}

    # Mail {{{
    email = {
      maildirBasePath = ".mail";

      primary = {
        name = "RandomNEET";
        primary = true;
        maildir.path = "/neet";
        address = "neet@randomneet.me";
        userName = "neet@randomneet.me";
        passwordCommand = "pass migadu/neet";
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
            folders-sort = "Inbox,Inbox/contact,Inbox/dev,Inbox/selfhost,Inbox/bill,Inbox/cert,Inbox/temp,Archive,Drafts,Sent,Junk,Trash";
            check-mail = "5m";
            check-mail-cmd = "systemctl --user start mbsync.service";
            check-mail-timeout = "30s";
          };
        };

        mbsync = {
          enable = true;
          create = "maildir";
        };
      };
    };

    mbsync = {
      program = {
        groups = {
          inboxes = {
            RandomNEET = [ "INBOX" ];
          };
        };
      };
      service = {
        configFile = "/home/${users.primary.name}/.vault/mail/mbsync/neet";
        notify = {
          enable = true;
          mailDir = "/home/${users.primary.name}/.mail/neet";
          countFile = "${mbsync.service.notify.mailDir}/.new";
        };
      };
    };
    # }}}

    # Media {{{
    mpd = {
      dataDir = "/mnt/hdd1/media/.mpd";
      musicDirectory = "/mnt/hdd1/media/music";
      startWhenNeeded = true;
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
      outputType = "pipewire";
    };

    rmpc = {
      config = {
        address = "127.0.0.1:6600";
        password = "None";
        notify = true;
      };
    };
    # }}}

    # Misc {{{
    git = {
      settings = {
        user = {
          name = "RandomNEET";
          email = "dev@randomneet.me";
        };
        init = {
          defaultBranch = "master";
        };
        advice = {
          defaultBranchName = false;
        };
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
    # }}}

    # Desktop {{{
    desktop = "hyprland";
    theme = "catppuccin-mocha";

    display = [
      {
        output = "DP-1";
        width = 3840;
        height = 2160;
        orientation = "landscape";
      }
      {
        output = "HDMI-A-1";
        width = 2160;
        height = 3840;
        orientation = "portrait";
      }
    ];

    hibernate = false;

    wallpaper = {
      dir = "/home/${users.primary.name}/pic/wallpapers";
      landscapeDir = "${wallpaper.dir}/landscape";
      portraitDir = "${wallpaper.dir}/portrait";
      transition = {
        type = "center";
        step = 90;
        duration = 1;
        fps = 60;
      };
    };

    hyprland = {
      monitor = [
        "desc:SAC G7u Pro 0001, 3840x2160@160, 0x0, 1.5"
        "desc:KOS KOIOS K2718UD 0000000000000, 3840x2160@60, 2560x-600, 1.5, transform, 1"
      ];
      workspaceBinds = ''
        workspace = 1, monitor:desc:SAC G7u Pro 0001, default:true;
        workspace = 10, monitor:desc:KOS KOIOS K2718UD 0000000000000, default:true;
      '';
    };

    hypridle = {
      time = {
        lock = "1800";
        dpmsOff = "3600";
        sleep = "";
      };
    };

    hyprlock = {
      background = "${wallpaper.dir}/landscape/touhou/marisa-reimu-3.jpg";
    };
  };
  # }}}

  # Package {{{
  flatpak = {
    packages = {
      system = [ ];
      home = [
        "com.github.tchx84.Flatseal"
        "com.qq.QQ"
        "com.tencent.WeChat"
      ];
    };
  };

  games = {
    packages = {
      home = [
        "osu-lazer"
        "prismlauncher"
      ];
    };
  };

  packages = {
    home = [
      "_7zz"
      "unrar"

      "ffmpeg"
      "imagemagick"

      "asciiquarium-transparent"
      "cbonsai"
      "cowsay"
      "cmatrix"
      "fortune"
      "figlet"
      "lolcat"
      "pipes"
      "tty-clock"

      "qbittorrent"

      "gimp"
      "libreoffice"
    ];
  };
  # }}}
}
