{
  lib,
  pkgs,
  meta,
  ...
}:
{
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
  };

  programs = {
    ssh = {
      matchBlocks = {
        zenith = {
          hostname = "zenith.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/zenith";
          addKeysToAgent = "yes";
        };
        gale = {
          hostname = "gale.local";
          port = 22;
          user = meta.username;
          identityFile = "/home/${meta.username}/.config/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
      };
    };
    zsh = {
      initContent = lib.mkAfter ''
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
      '';
    };
  };
  services = {
    mpd = {
      network = {
        listenAddress = "0.0.0.0";
        startWhenNeeded = true;
      };
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
  };
  home = {
    packages = with pkgs; [
      mediainfo
      flac

      lolcat
      figlet
      fortune
      cowsay
      asciiquarium-transparent
      cbonsai
      cmatrix
      pipes
      tty-clock

      qq
    ];
  };

  sops = {
    secrets = {
      "ssh/zenith".sopsFile = ./secrets.yaml;
      "ssh/gale".sopsFile = ./secrets.yaml;
    };
  };
}
