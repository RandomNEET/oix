# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # System {{{
  # Base {{{
  hostname = "lix";
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

  # Available cores: dae sing-box xray
  proxy = {
    dae = {
      enable = true;
      configFile = "/run/secrets/dae";
      openFirewall = {
        enable = true;
        port = 12345;
      };
    };
  };
  sops.secrets.dae.sopsFile = ./secrets.yaml;
  systemd.system.services.dae.after = [ "sops-nix.service" ];
  # }}}

  # Users {{{
  users = {
    root = {
      initialHashedPassword = "$6$1bNtqKFsObhMC1OG$THnog0HqmR/GnN.0IwndZzuijVMiV0cZIPUjmCvDs6gsjHAc.FYfcIlKmiMx2hy2gbd814Br1uNAhiyKl4W9g.";
    };
    primary = rec {
      # User config
      name = "howl";
      initialHashedPassword = "$6$.FVrKngH1eXjNYi9$lsTAUQvvJyB209fhkf3g5E12iCcgNdDZKW0XTwCp7i3lNwM8gjNq3kRgjW4WIBV68YETysoDCHhKtSIncPT3n1";
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
      home-manager = true; # whether to enable home-manager for this user
      xdg = {
        userDirs = {
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
    mutableUsers = false;
  };

  # Define default programs
  editor = "nvim";
  terminal = "foot";
  terminalFileManager = "yazi";
  browser = "qutebrowser";
  # }}}

  # Packages {{{
  packages =
    pkgs: with pkgs; {
      system = [
        veracrypt
      ];
      home = [
        ffmpeg
        imagemagick
        md2pdf

        qbittorrent
        libreoffice

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
  # }}}

  # Misc {{{
  locale = "en_US.UTF-8";
  timezone = "Asia/Shanghai";
  kbdLayout = "us";
  consoleKeymap = "us";
  # }}}
  # }}}

  # Hardware {{{
  gpu = "intel-integrated"; # available: amd nvidia intel-intergrated
  # }}}

  # Services {{{
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
      "dix" = {
        hostname = "dix.local";
        port = 22;
        user = "howl";
        identityFile = "/run/secrets/ssh/dix";
        addKeysToAgent = "yes";
      };
      "nasix" = {
        hostname = "nasix.local";
        port = 22;
        user = "howl";
        identityFile = "/run/secrets/ssh/nasix";
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
    "ssh/dix" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
    "ssh/nasix" = {
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

  foot = {
    server = true; # set true to launch foot server on startup;
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
    dir = "${users.primary.xdg.userDirs.pictures}/wallpapers";
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

  hibernate = true; # set to true if this machine supports hibernate

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
        avatarImage = "${users.primary.xdg.userDirs.pictures}/avatars/weeb.jpg";
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
}
