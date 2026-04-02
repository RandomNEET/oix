# vim:foldmethod=marker:foldlevel=0
{ outputs, lib, ... }:
rec {
  # System {{{
  # Base {{{
  hostname = "voile";
  system = "x86_64-linux"; # x86_64-linux aarch64-linux
  flake = "/home/${users.primary.name}/oix"; # flake path
  channel = "stable"; # nixpkgs channel; unstable or stable
  # }}}

  # Boot {{{
  boot = {
    kernelPackages = pkgs: with pkgs; linuxPackages; # linuxPackages_(latest|zen|lts|hardened|rt|rt_latest)
  };
  # }}}

  # Network {{{
  firewall = {
    enable = true;
    allowedTCPPorts = [
      5900
      6600
      6881
      7102
      8000
      9997
      9998
      9999
      10000
      10090
      10100
      10110
      10120
      10200
      10225
      10230
      10240
      10250
      10300
      10310
      10320
      10330
      10340
      10400
      10500
      61208
    ];
    allowedUDPPorts = [ 6881 ];
  };

  xray.settingsFile = "/run/secrets/xray";
  sops.secrets.xray.sopsFile = ./secrets.yaml;
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
        "docker"
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
  terminalFileManager = "yazi";
  # }}}

  # Packages {{{
  packages =
    pkgs: with pkgs; {
      home = [
        mediainfo
        flac

        qq

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
  gpu = "nvidia"; # available: amd nvidia intel-intergrated
  # }}}

  # Services {{{
  openssh = {
    ports = [ 22 ];
    authorizedKeysFiles = [ "/run/secrets/ssh/${users.primary.name}@${hostname}" ];
  };
  sops.secrets."ssh/${users.primary.name}@${hostname}" = {
    sopsFile = ./secrets.yaml;
    owner = users.primary.name;
  };

  systemd.system.services = {
    xray = {
      after = [
        "sops-nix.service"
        "docker.service"
      ];
    };
    docker = {
      serviceConfig = {
        Environment = [
          "http_proxy=http://127.0.0.1:9998"
          "https_proxy=http://127.0.0.1:9998"
        ];
      };
    };
    mpd = {
      after = [
        "mnt-smb.mount"
      ];
      requires = [
        "mnt-smb.mount"
      ];
    };
    qbot = {
      description = "NapCat Draw Bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "${users.primary.name}";
        WorkingDirectory = "/home/howl/repo/qbot";
        ExecStart = "/etc/profiles/per-user/howl/bin/direnv exec /home/howl/repo/qbot python /home/howl/repo/qbot/qbot-listen.py";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };

  mpd = {
    dataDir = "/mnt/smb/media/.mpd";
    musicDirectory = "/mnt/smb/media/music";
    extraConfig = ''
      audio_output {
          type        "httpd"
          name        "MPD HTTP Stream"
          encoder     "vorbis"
          port        "8000"
          quality     "5.0"
      }
    '';
  };

  tlp = {
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
  # }}}

  # Programs {{{
  ssh = {
    matchBlocks = {
      zenith = {
        hostname = "zenith.local";
        port = 22;
        user = users.primary.name;
        identityFile = "/run/secrets/ssh/zenith";
        addKeysToAgent = "yes";
      };
      gale = {
        hostname = "gale.local";
        port = 22;
        user = users.primary.name;
        identityFile = "/run/secrets/ssh/gale";
        addKeysToAgent = "yes";
      };
    };
  };
  sops.secrets = {
    "ssh/zenith" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
    "ssh/gale" = {
      sopsFile = ./secrets.yaml;
      owner = users.primary.name;
    };
  };

  zsh = {
    initContent = [
      (lib.mkOrder 500 ''
        if [[ -z "$TMUX" ]]; then
          local host_name=$(hostname)
          
          local raw_uptime=$(cat /proc/uptime | awk '{print int($1)}')
          local days=$((raw_uptime / 86400))
          local hours=$(( (raw_uptime % 86400) / 3600 ))
          local mins=$(( (raw_uptime % 3600) / 60 ))
          local up_time="''${days}d ''${hours}h ''${mins}m"

          local cpu_cores=$(nproc)
          local load_1=$(awk '{print $1}' /proc/loadavg)
          local usage_pct=$(printf "%.1f" $(( load_1 * 100.0 / cpu_cores )))

          local mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
          local mem_avail=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
          local mem_usage=$(( 100 - (mem_avail * 100 / mem_total) ))

          local disk_root=$(df -h / | awk 'NR==2 {print $5}')
          local disk_smb=$(df -h /mnt/smb | awk 'NR==2 {print $5}')

          local cyan="\e[1;36m"
          local green="\e[1;32m"
          local yellow="\e[1;33m"
          local blue="\e[1;34m"
          local magenta="\e[1;35m"
          local reset="\e[0m"
          local dim="\e[2m"

          echo -e "''${blue}╭──────────────────────────────────────────────────╮''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰒄  Host:''${reset} ''${green}''${host_name}''${reset} (Ryzen 7 5800H)"
          echo -e "''${blue}│''${reset}  ''${cyan}󱎫  Up:''${reset}   ''${yellow}''${up_time}''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰓅  Load:''${reset}  ''${green}''${load_1}''${reset} ''${dim}(Usage: ''${usage_pct}% of ''${cpu_cores} cores)''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰍛  Mem:''${reset}   ''${magenta}''${mem_usage}%''${reset} ''${dim}used''${reset}"
          echo -e "''${blue}│''${reset}  ''${cyan}󰋊  Disk:''${reset}  ''${blue}/: ''${disk_root}''${reset} ''${dim}|''${reset} ''${blue}SMB: ''${disk_smb}''${reset}"
          echo -e "''${blue}╰──────────────────────────────────────────────────╯''${reset}"
        fi
      '')
    ];
  };
  # }}}
}
