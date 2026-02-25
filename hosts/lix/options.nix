# vim:fileencoding=utf-8:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # Base {{{
  hostname = "lix";
  system = "x86_64-linux";
  gpu = "intel-integrated"; # available: amd nvidia intel-intergrated
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  hibernate = true; # set to true if this machine supports hibernate
  # }}}

  # Boot {{{
  boot = {
    kernelPackages = "linuxPackages_zen"; # linuxPackages_(latest|zen|lts|hardened|rt|rt_latest)
  };
  # }}}

  # Network {{{
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

  # Desktop {{{
  desktop = "niri-noctalia"; # available: hyprland-noctalia hyprland-waybar niri-noctalia niri-waybar

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
      output = "eDP-1";
      external = false;
      width = 1920;
      height = 1080;
      orientation = "landscape";
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
    settings = {
      monitor = [
        "desc:Chimei Innolux Corporation 0x14C9, 1920x1080@60, 0x0, 1"
      ];
    };
    extraConfig = ''
      workspace = 1, monitor:desc:Chimei Innolux Corporation 0x14C9, default:true;
    '';
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

  noctalia = {
    settings = {
      general = {
        avatarImage = "${xdg.userDirs.pictures}/avatars/weeb.jpg";
      };
      location = {
        name = "Jiangxi";
      };
    };
  };

  hyprlock = {
    background = "${wallpaper.dir}/original/landscape/touhou/marisa-reimu-3.jpg";
  };

  swaylock = {
    image = "eDP-1:${wallpaper.dir}/original/landscape/touhou/marisa-reimu-3.jpg";
  };
  # }}}

  # Hardware {{{
  tlp = {
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };

  kmonad = {
    keyboards = {
      T480 = {
        name = "T480";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = ''
          (defcfg
            input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
            output (uinput-sink "T480")
            fallthrough true
          )
          (defsrc
                 mute vold volu
          esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
            grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '          ret
            lsft z    x    c    v    b    n    m    ,    .    /               rsft
            wkup lctl lmet lalt           spc            ralt sys  rctl  pgdn up   pgup
          )
          (defalias 
            mod (layer-toggle mod1)
          )
          (deflayer mod0
                 mute vold volu
          esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
            grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
            lctl a    s    d    f    g    h    j    k    l    ;    '          ret
            lsft z    x    c    v    b    n    m    ,    .    /               rsft
            wkup lctl lmet lalt           spc            ralt sys  @mod  pgdn up   pgup
          )
          (deflayer mod1
                 mute vold volu
          esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  home end  ins  del
            grv  1    2    3    4    5    6    7    8    9    0    -     =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [     ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '          ret
            lsft z    x    c    v    b    n    m    ,    .    /               rsft
            wkup lctl lmet lalt           spc            ralt sys  rctl  pgdn up   pgup
          )
        '';
        extraGroups = [
          "input"
          "uinput"
        ];
        enableHardening = true;
      };
    };
  };
  # }}}

  # user {{{
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
  terminal = "foot";
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
      authorizedKeysFiles = [ "${ssh.keyDir}/lix.pub" ];
    };

    client = {
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "${ssh.keyDir}/github-RandomNEET";
          addKeysToAgent = "yes";
        };
        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = "${ssh.keyDir}/codeberg-RandomNEET";
          addKeysToAgent = "yes";
        };
        "dix" = {
          hostname = "dix.local";
          port = 22;
          user = "howl";
          identityFile = "${ssh.keyDir}/dix";
          addKeysToAgent = "yes";
        };
        "nasix" = {
          hostname = "nasix.local";
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
      opacity0 = 1.0;
      opacity1 = 1.0;
    };
    window = {
      hide_decoration = true;
      transparent = false;
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
    dataDir = "/home/${users.primary.name}/.local/share/mpd";
    startWhenNeeded = true;
    settings = {
      music_directory = "/home/${users.primary.name}/mus";
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
  };
  # }}}
}
