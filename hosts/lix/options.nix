{
  inputs,
  outputs,
  lib,
  ...
}:
{
  opts = rec {
    # System
    hostname = "lix";
    system = "x86_64-linux";
    gpu = "intel-integrated";
    locale = "en_US.UTF-8";
    timezone = "Asia/Shanghai";
    kbdLayout = "us";
    consoleKeymap = "us";
    boot = {
      kernelPackages = "linuxPackages_zen"; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/nix/persist/var/lib/sbctl";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    ip = {
      local = "192.168.0.69";
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
        ];
        shell = "zsh";
      };
    };

    # User environment
    editor = "nvim";
    terminal = "kitty";
    terminalFileManager = "yazi";
    browser = "qutebrowser"; # firefox qutebrowser
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
              wkup @mod lmet lalt           spc            ralt sys  rctl  pgdn up   pgup
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

    mbsync = {
      configFile = "/home/${users.default.name}/.vault/mail/mbsync/RandomNEET";
      preExec = "/run/current-system/sw/bin/mkdir -p /home/${users.default.name}/.mail/neet";
    };

    mpd = {
      dataDir = "/home/${users.default.name}/.local/share/mpd";
      musicDirectory = "/home/${users.default.name}/mus";
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

    proxy = {
      # dae xray
      dae = {
        configFile = "/home/${users.default.name}/.vault/proxy/dae/default.dae";
        openFirewall = {
          enable = true;
          port = 12345;
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
        authorizedKeysFiles = [ "${ssh.keysDir}/lix.pub" ];
      };

      client = {
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "${ssh.keysDir}/gh-randomneet";
            addKeysToAgent = "yes";
          };
          "dix" = {
            hostname = outputs.nixosConfigurations.dix._module.specialArgs.opts.ip.local;
            port = 22;
            user = "howl";
            identityFile = "${ssh.keysDir}/dix";
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

    tlp = {
      settings = {
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        START_CHARGE_THRESH_BAT1 = 40;
        STOP_CHARGE_THRESH_BAT1 = 80;
      };
    };

    # Programs
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

    gpg = {
      homedir = "/home/${users.default.name}/.gnupg";
      agent = {
        enable = true;
        enableSshSupport = true; # Automatically disable ssh-agent if set to true
      };
    };

    nixvim = {
      withNodeJs = false;
      withPerl = false;
      withPython3 = true;
      withRuby = false;

      lsp.enable = true;
      treesitter.enable = true; # Automatically disable noice if set to false
      lint.enable = true;
      conform.enable = true;
      copilot = {
        enable = true;
        cmp = false;
      };
      noice.enable = true; # Require treesitter
      snack = {
        image.enable = true;
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

    rbw = {
      settings = {
        base_url = "https://vaultwarden.scaphium.xyz";
        email = "selfhost@randomneet.me";
        lock_timeout = 3600;
      };
      rofi-rbw = true;
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
        theme = "simple";
      };
    };

    firefox = {
      network.trr = {
        mode = 3; # 0 - Off (default), 1 - Reserved, 2 - First, 3 - Only
        uri = "https://dns.alidns.com/dns-query";
        custom_uri = "https://dns.alidns.com/dns-query";
      };
      browser.startup.homepage = "https://startpage.randomneet.me/";
      DisableFirefoxAccounts = false;
      titlebar-buttons-disable = true;
      full-screen-api.ignore-widgets = true;
    };

    obsidian = {
      vaults = {
        default = {
          enable = true;
          target = "doc/notes";
        };
      };
    };

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
        mgd = "https://webmail.migadu.com/";
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

        "libreoffice"
      ];
    };
    # Desktop
    desktop = "niri"; # hyprland niri
    theme = "catppuccin-mocha"; # catppuccin-mocha

    display = [
      {
        output = "eDP-1";
        width = 1920;
        height = 1080;
        orientation = "landscape";
      }
    ];

    hibernate = true;

    wallpaper = {
      dir = "/home/${users.default.name}/pic/wallpapers";
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
        "desc:Chimei Innolux Corporation 0x14C9, 1920x1080@60, 0x0, 1"
      ];
      workspaceBinds = ''
        workspace = 1, monitor:desc:Chimei Innolux Corporation 0x14C9, default:true;
      '';
    };

    hypridle = {
      time = {
        lock = "300";
        dpmsOff = "1800";
        sleep = "3600";
      };
    };

    hyprlock = {
      background = "${wallpaper.dir}/landscape/touhou/marisa-reimu-3.jpg";
    };

    niri = {
      output = [
        {
          name = "eDP-1";
          off = false;
          mode = "1920x1080@60.008";
          scale = 1.25;
          transform = "normal";
          position = {
            x = 0;
            y = 0;
          };
          variable-refresh-rate = false;
          focus-at-startup = true;
        }
      ];
    };

    swayidle = {
      time = {
        lock = 300;
        dpmsOff = 1800;
        sleep = 3600;
      };
    };

    swaylock = {
      image = "eDP-1:${wallpaper.dir}/landscape/touhou/marisa-reimu-3.jpg";
    };
  };
}
