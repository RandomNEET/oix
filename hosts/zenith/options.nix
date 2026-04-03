# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # System {{{
  # Base {{{
  hostname = "zenith";
  system = "x86_64-linux"; # x86_64-linux aarch64-linux
  flake = "/home/${users.primary.name}/oix"; # flake path
  channel = "unstable"; # nixpkgs channel; unstable or stable
  # }}}

  # Boot {{{
  boot = {
    kernelPackages = pkgs: with pkgs; linuxPackages_zen; # linuxPackages_(latest|zen|lts|hardened|rt|rt_latest)
  };
  # }}}

  # Network {{{
  firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  dae.configFile = "/run/secrets/dae";
  sops.secrets.dae.sopsFile = ./secrets.yaml;
  systemd.system.services.dae.after = [ "sops-nix.service" ];
  # }}}

  # Users {{{
  users = {
    root = {
      hashedPasswordFile = "/run/secrets-for-users/users/root/password";
    };
    primary = rec {
      # User config
      name = "howl";
      hashedPasswordFile = "/run/secrets-for-users/users/${name}/password";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "i2c"
      ];
      shell = "zsh";
      # Home-manager config
      home-manager = {
        enable = true; # whether to enable home-manager for this user
        xdg = {
          userDirs = {
            enable = true;
            desktop = null; # no need for wm
            documents = "/home/${name}/doc";
            download = "/home/${name}/dls";
            music = "/home/${name}/mus";
            pictures = "/home/${name}/pic";
            videos = "/home/${name}/vid";
            templates = "/home/${name}/tpl";
            publicShare = "/home/${name}/pub";
          };
        };
      };
    };
    mutableUsers = false;
  };
  sops.secrets = {
    "users/root/password" = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
    "users/${users.primary.name}/password" = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  # Define default programs
  editor = "nvim";
  terminal = "kitty";
  terminalFileManager = "yazi";
  browser = "qutebrowser";
  # }}}

  # Packages {{{
  packages =
    pkgs: with pkgs; {
      system = [
        ddcutil
        veracrypt
      ];
      home = [
        ffmpeg
        imagemagick
        md2pdf

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

        osu-lazer
        prismlauncher
      ];
    };
  # }}}

  # Misc {{{
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  # }}}
  # }}}

  # Hardware {{{
  gpu = "nvidia"; # available: amd nvidia intel-intergrated
  # }}}

  # Virtualisation {{{
  libvirtd = {
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
  # }}}

  # Services {{{
  udev = {
    extraRules = ''
      # Disable wake-on-USB for Logitech G502X Receiver to prevent accidental wakeups from sleep/suspend
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ENV{DEVTYPE}=="usb_device", ATTR{power/wakeup}="disabled"
    '';
  };

  openssh = {
    ports = [ 22 ];
    authorizedKeysFiles = [ "/run/secrets/ssh/${users.primary.name}@${hostname}" ];
  };
  sops.secrets."ssh/${users.primary.name}@${hostname}" = {
    sopsFile = ./secrets.yaml;
    owner = users.primary.name;
  };

  mbsync.service = {
    configFile = "/run/secrets/mbsync";
    mailDir = "/home/${users.primary.name}/${email.maildirBasePath}";
    countFile = "${mbsync.service.mailDir}/.new";
    triggerFile = "${mbsync.service.mailDir}/.trigger";
  };
  sops.secrets.mbsync = {
    sopsFile = ./secrets.yaml;
    owner = users.primary.name;
  };
  systemd.home.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

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

  flatpak = {
    packages = {
      home = [
        "com.github.tchx84.Flatseal"

        "com.qq.QQ"
        "com.tencent.WeChat"
      ];
    };
  };
  # }}}

  # Programs {{{
  ssh = {
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "/run/secrets/ssh/github-RandomNEET";
        addKeysToAgent = "yes";
      };
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = "/run/secrets/ssh/codeberg-RandomNEET";
        addKeysToAgent = "yes";
      };
      gale = {
        hostname = "gale.local";
        port = 22;
        user = users.primary.name;
        identityFile = "/run/secrets/ssh/gale";
        addKeysToAgent = "yes";
      };
      voile = {
        hostname = "voile.local";
        port = 22;
        user = users.primary.name;
        identityFile = "/run/secrets/ssh/voile";
        addKeysToAgent = "yes";
      };
    };
  };
  sops.secrets = {
    "ssh/github-RandomNEET" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
    "ssh/codeberg-RandomNEET" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
    "ssh/gale" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
    "ssh/voile" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
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

  git = {
    settings = {
      user = {
        name = "RandomNEET";
        email = "dev@randomneet.me";
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
  # }}}

  # Accounts {{{
  email = {
    maildirBasePath = ".mail";

    primary = {
      name = "RandomNEET";
      primary = true;
      maildir.path = "/neet";
      address = "neet@randomneet.me";
      userName = "neet@randomneet.me";
      passwordCommand = "cat /run/secrets/email/${email.primary.name}/password";
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
          check-mail-cmd = "mbsync ${email.primary.name}";
          check-mail-timeout = "30s";
        };
      };

      mbsync = {
        enable = true;
        create = "maildir";
      };
    };
  };
  sops.secrets."email/${email.primary.name}/password" = {
    sopsFile = ./secrets.yaml;
    owner = users.primary.name;
  };
  # }}}

  # Desktop {{{
  desktop = "hyprland-noctalia"; # available: hyprland-noctalia hyprland-waybar niri-noctalia niri-waybar

  # https://github.com/tinted-theming/schemes
  # Default to the first theme
  themes = [
    "catppuccin-mocha"
    "gruvbox-dark-hard"
    "kanagawa"
    "nord"
    "tokyo-night-dark"
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
    # - Original colored pictures belong in the "original" theme folder.
    # - Valid orientations: "landscape", "portrait".
    #
    # Example:
    #  wallpapers
    # ├──  catppuccin-mocha
    # │   ├──  landscape
    # │   │   └──  pic.jpg
    # │   └──  portrait
    # │       └──  pic.jpg
    # └──  original
    #     ├──  landscape
    #     │   └──  pic.jpg
    #     └──  portrait
    #         └──  pic.jpg
    dir = "${users.primary.home-manager.xdg.userDirs.pictures}/wallpapers";
  };

  hibernate = false; # set to true if this machine supports hibernate

  hyprland = {
    settings = {
      monitor = [
        "desc:SAC G7u Pro 0001, 3840x2160@160, 0x0, 1.5"
        "desc:KOS KOIOS K2718UD 0000000000000, 3840x2160@60, 2560x-600, 1.5, transform, 1"
      ];
      bind = [
        "$mainMod, F1, exec, noctalia-shell ipc call volume muteOutput"
        "$mainMod, F4, exec, noctalia-shell ipc call volume muteInput"
        "$mainMod, F7, exec, noctalia-shell ipc call media previous"
        "$mainMod, F8, exec, noctalia-shell ipc call media playPause"
        "$mainMod, F9, exec, noctalia-shell ipc call media next"
      ];
      binde = [
        "$mainMod, F2, exec, noctalia-shell ipc call volume decrease"
        "$mainMod, F3, exec, noctalia-shell ipc call volume increase"
        "$mainMod, F5, exec, noctalia-shell ipc call brightness decrease"
        "$mainMod, F6, exec, noctalia-shell ipc call brightness increase"
      ];
    };
    extraConfig = ''
      workspace = 1, monitor:desc:SAC G7u Pro 0001, default:true;
      workspace = 10, monitor:desc:KOS KOIOS K2718UD 0000000000000, default:true;
    '';
    showKeybinds = [
      {
        key = "SUPER F1";
        desc = "Mute output";
        cmd = "noctalia volume muteOutput";
      }
      {
        key = "SUPER F2";
        desc = "Lower volume";
        cmd = "noctalia volume decrease";
      }
      {
        key = "SUPER F3";
        desc = "Increase volume";
        cmd = "noctalia volume increase";
      }
      {
        key = "SUPER F4";
        desc = "Mute input";
        cmd = "noctalia volume muteInput";
      }
      {
        key = "SUPER F5";
        desc = "Decrease brightness";
        cmd = "noctalia brightness decrease";
      }
      {
        key = "SUPER F6";
        desc = "Increase brightness";
        cmd = "noctalia brightness increase";
      }
      {
        key = "SUPER F7";
        desc = "Previous media track";
        cmd = "noctalia media previous";
      }
      {
        key = "SUPER F8";
        desc = "Play/Pause media";
        cmd = "noctalia media playPause";
      }
      {
        key = "SUPER F9";
        desc = "Next media track";
        cmd = "noctalia media next";
      }
    ];
  };

  niri = {
    settings = {
      outputs = {
        "DP-1" = {
          enable = true;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 144.00;
          };
          scale = 1.5;
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = "on-demand";
          focus-at-startup = true;
        };
        "HDMI-A-1" = {
          enable = true;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 60.00;
          };
          scale = 1.5;
          transform = {
            rotation = 90;
          };
          position = {
            x = 2560;
            y = -600;
          };
        };
      };
      binds = {
        "Mod+F1" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "muteOutput"
          ];
          allow-when-locked = true;
        };
        "Mod+F2" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "decrease"
          ];
          allow-when-locked = true;
        };
        "Mod+F3" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "increase"
          ];
          allow-when-locked = true;
        };
        "Mod+F4" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "muteInput"
          ];
          allow-when-locked = true;
        };
        "Mod+F5" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "decrease"
          ];
          allow-when-locked = true;
        };
        "Mod+F6" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "brightness"
            "increase"
          ];
          allow-when-locked = true;
        };
        "Mod+F7" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "media"
            "previous"
          ];
          allow-when-locked = true;
        };
        "Mod+F8" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "media"
            "playPause"
          ];
          allow-when-locked = true;
        };
        "Mod+F9" = {
          action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "media"
            "next"
          ];
          allow-when-locked = true;
        };
      };
    };
  };

  noctalia = {
    settings = {
      general = {
        avatarImage = "${users.primary.home-manager.xdg.userDirs.pictures}/avatars/weeb.jpg";
      };
      bar = {
        screenOverrides = [
          {
            enabled = true;
            name = "HDMI-A-1";
            position = "top";
            density = "default";
            widgets = {
              center = [
                {
                  id = "Clock";
                  formatHorizontal = "ddd MMM d HH:mm";
                  formatVertical = "MM dd - HH mm";
                  tooltipFormat = "yyyy-MM-dd HH:mm:ss";
                }
              ];
              left = [
                {
                  id = "Workspace";
                }
              ];
              right = [
                {
                  id = "AudioVisualizer";
                  hideWhenIdle = true;
                }
              ];
            };
          }
        ];
      };
      sessionMenu = {
        powerOptions = [
          {
            action = "lock";
            enabled = true;
            countdownEnabled = true;
            keybind = "1";
          }
          {
            action = "suspend";
            enabled = true;
            countdownEnabled = true;
            keybind = "2";
          }
          {
            action = "reboot";
            enabled = true;
            countdownEnabled = true;
            keybind = "3";
          }

          {
            action = "logout";
            enabled = true;
            countdownEnabled = true;
            keybind = "4";
          }
          {
            action = "shutdown";
            enabled = true;
            countdownEnabled = true;
            keybind = "5";
          }
          {
            action = "rebootToUefi";
            enabled = true;
            countdownEnabled = true;
            keybind = "6";
          }
        ];
      };
      location = {
        name = "Jiangxi";
      };
      brightness = {
        enableDdcSupport = true;
      };
    };
  };
  # }}}
}
