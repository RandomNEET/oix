# vim:fileencoding=utf-8:foldmethod=marker
{ outputs, lib, ... }:
{
  opts = rec {
    # Base {{{
    hostname = "dix";
    system = "x86_64-linux";
    gpu = "nvidia"; # available: amd nvidia intel-intergrated
    locale = "en_US.UTF-8";
    timezone = "Asia/Shanghai";
    kbdLayout = "us";
    consoleKeymap = "us";
    hibernate = false; # set to true if this machine supports hibernate
    # }}}

    # Boot {{{
    boot = {
      kernelPackages = "linuxPackages_zen"; # linuxPackages_(latest|zen|lts|hardened|rt|rt_latest)
    };

    # Secure Boot
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

    # Available cores: dae sing-box xray
    proxy = {
      dae = {
        enable = true;
        configFile = "/home/${users.primary.name}/.vault/proxy/dae/default.dae";
        openFirewall = {
          enable = true;
          port = 12345;
        };
      };
    };
    # }}}

    # Virtualisation {{{
    virtualisation = {
      vm = {
        enable = true;
        virt-manager = {
          enable = true;
        };
        hooks = {
          qemu = {
            auto-mount = ''
              VM_NAME="win11-native"
              if [ "$1" = "$VM_NAME" ]; then
                  case "$2" in
                      prepare)
                          umount -l /mnt/ssd || true 
                          ;;
                      stopped|release)
                          if ! mountpoint -q /mnt/ssd; then
                              mount /mnt/ssd || true
                          fi
                          ;;
                  esac
              fi
            '';
          };
        };
      };
    };
    # }}}

    # Desktop {{{
    desktop = "hyprland"; # available: hyprland niri

    # https://github.com/tinted-theming/schemes
    # Default to the first theme
    themes = [
      "catppuccin-mocha"
      "everforest-dark-hard"
      "gruvbox-dark-hard"
      "kanagawa"
      "nord"
    ];

    # Use first display as primary display
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

    wallpaper = {
      # Base directory for wallpapers
      # Required structure: base / <theme_name> / <orientation> / <pictures>
      #
      # Notes:
      # - Original colored pictures belong in the "default" theme folder.
      # - Valid orientations: "landscape", "portrait".
      #
      # Example:
      #  wallpapers
      # ├──  catppuccin
      # │   ├──  landscape
      # │   │   └──  pic.jpg
      # │   └──  portrait
      # │       └──  pic.jpg
      # └──  default
      #     ├──  landscape
      #     │   └──  pic.jpg
      #     └──  portrait
      #         └──  pic.jpg
      dir = "${xdg.userDirs.pictures}/wallpapers";
      # Transition effects for swww
      transition = {
        launcher = {
          type = "center";
          step = 90;
          duration = 1;
          fps = 60;
        };
        random-wall = {
          type = "wipe";
          step = 90;
          duration = 1;
          fps = 60;
        };
      };
    };

    hyprland = {
      monitor = [
        "desc:SAC G7u Pro 0001, 3840x2160@160, 0x0, 1.5"
        "desc:KOS KOIOS K2718UD 0000000000000, 3840x2160@60, 2560x-600, 1.5, transform, 1"
      ];
      extraConfig = ''
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
      background = "${wallpaper.dir}/default/landscape/touhou/marisa-reimu-3.jpg";
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
        ];
        shell = "zsh";
      };
    };

    # Define default programs
    editor = "nvim";
    terminal = "kitty";
    terminalFileManager = "yazi";
    browser = "qutebrowser";

    xdg = {
      userDirs = {
        desktop = null; # no need for wm
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
        authorizedKeysFiles = [ "${ssh.keyDir}/dix.pub" ];
      };

      client = {
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "${ssh.keyDir}/gh-randomneet";
            addKeysToAgent = "yes";
          };
          "lix" = {
            hostname = outputs.nixosConfigurations.lix._module.specialArgs.opts.ip.local;
            port = 22;
            user = "howl";
            identityFile = "${ssh.keyDir}/lix";
            addKeysToAgent = "yes";
          };
          "nasix" = {
            hostname = outputs.nixosConfigurations.nasix._module.specialArgs.opts.ip.local;
            port = 22;
            user = "howl";
            identityFile = "${ssh.keyDir}/nasix";
            addKeysToAgent = "yes";
          };
        };
      };
    };
    # }}}

    # Terminal {{{
    foot = {
      server = true; # set true to launch foot server on startup;
    };
    # }}}

    # File Manager {{{
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
    # }}}

    # Browser {{{
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
            folders-sort = "Inbox,Inbox/dev,Inbox/contact,Inbox/selfhost,Inbox/bill,Inbox/cert,Inbox/temp,Archive,Drafts,Sent,Junk,Trash";
            check-mail = "5m";
            check-mail-cmd = "touch /home/${users.primary.name}/${email.maildirBasePath}/.trigger && sleep 1";
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
            RandomNEET = [
              "INBOX"
              "INBOX/dev"
              "INBOX/contact"
              "INBOX/selfhost"
              "INBOX/bill"
              "INBOX/cert"
              "INBOX/temp"
            ];
          };
        };
      };
      service = {
        configFile = "/home/${users.primary.name}/.vault/mail/mbsync/neet";
        # Desktop notification script settings
        notify = {
          enable = true;
          mailDir = "/home/${users.primary.name}/.mail/neet";
          countFile = "${mbsync.service.notify.mailDir}/.new";
        };
        trigger.enable = true; # whether to enable mbsync-trigger service
      };
    };
    # }}}

    # Media {{{
    mpd = {
      dataDir = "/mnt/hdd1/media/.mpd";
      startWhenNeeded = true;
      settings = {
        music_directory = "/mnt/hdd1/media/music";
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Sound Server";
          }
          {
            type = "fifo";
            name = "my_fifo";
            path = "/tmp/mpd.fifo";
            format = "44100:16:2";
          }
        ];
        auto_update = "yes";
      };
      pipewire = true; # set to true to enable pipewire extra tweaks
    };

    rmpc = {
      config = {
        address = "127.0.0.1:6600";
        password = "None";
        notify = true; # whether to enable desktop notification
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

    rbw = {
      settings = {
        base_url = "https://vaultwarden.scaphium.xyz";
        email = "selfhost@randomneet.me";
        lock_timeout = 3600;
      };
      rofi-rbw = true; # install rofi-rbw, add related keybind to wm and use graphical pinentry if set to true
    };
    # }}}

    # Package {{{
    packages = {
      home = [
        "ffmpeg"
        "imagemagick"
        "lolcat"
        "figlet"
        "fortune"
        "cowsay"
        "asciiquarium-transparent"
        "cbonsai"
        "cmatrix"
        "pipes"
        "tty-clock"
        "qbittorrent"
        "libreoffice"
      ];

      flatpak = {
        home = [
          "com.github.tchx84.Flatseal"
          "com.qq.QQ"
          "com.tencent.WeChat"
        ];
      };

      games = {
        home = [
          "osu-lazer"
          "prismlauncher"
        ];
      };
    };
    # }}}
  };
}
