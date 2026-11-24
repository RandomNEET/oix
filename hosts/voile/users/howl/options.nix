{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.home.username;
in
{
  oix = {
    defaults = {
      editor = "nvim";
      fileManager = "yazi";
      browser = "w3m";
    };
  };

  programs = {
    ssh = {
      settings = {
        zenith = {
          hostname = "zenith.local";
          port = 22;
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/zenith";
          addKeysToAgent = "yes";
        };
        gale = {
          hostname = "gale.local";
          port = 22;
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        pi = {
          hostname = "pi.local";
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/pi";
          addKeysToAgent = "yes";
        };
        gale-ts = {
          hostname = "gale";
          port = 22;
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/gale";
          addKeysToAgent = "yes";
        };
        pi-ts = {
          hostname = "pi";
          user = username;
          identityFile = "${config.xdg.configHome}/sops-nix/secrets/ssh/pi";
          addKeysToAgent = "yes";
        };
      };
    };
    zsh = {
      loginExtra = ''
        if [[ -o interactive && "$TTY" == /dev/tty1 && -z "$SSH_CONNECTION" && -z "$TMUX" ]]; then
          if ${pkgs.tmux}/bin/tmux has-session -t '=monitor' 2>/dev/null; then
            ${pkgs.tmux}/bin/tmux attach-session -t '=monitor'
          else
            dashboard --all
          fi
        fi
      '';
      initContent = lib.mkAfter ''
        dashboard() (
          cbonsai() {
            tmux new-session -d -s monitor -n cbonsai "sleep 0.2 && cbonsai -li -t 10 -L 64"
          }

          cmatrix() {
            tmux new-session -d -s monitor -n cmatrix "sleep 0.2 && cmatrix -r"
          }

          asciiquarium() {
            tmux new-session -d -s monitor -n asciiquarium "sleep 0.2 && asciiquarium -t"
          }

          tty-clock() {
            tmux new-session -d -s monitor -n tty-clock "sleep 0.2 && tty-clock -cs -C 7"
          }

          all() {
            tmux new-session -d -s monitor -n cbonsai "sleep 0.2 && cbonsai -li -t 10 -L 64"
            tmux new-window -t monitor -n asciiquarium "asciiquarium -t"
            tmux new-window -t monitor -n cmatrix "cmatrix -r"
            tmux new-window -t monitor -n tty-clock "tty-clock -cs -C 7"
          }

          case "$1" in
          -cb | --cbonsai)
            cbonsai
            ;;
          -cm | --cmatrix)
            cmatrix
            ;;
          -aq | --asciiquarium)
            asciiquarium
            ;;
          -tc | --tty-clock)
            tty-clock
            ;;
          -a | --all)
            all
            ;;
          *)
            echo "Usage: $0 [-cb|--cbonsai] [-cm|--cmatrix] [-aq|--asciiquarium] [-tc|--tty-clock] [-a|--all]"
            exit 1
            ;;
          esac

          tmux new-window -t monitor -n gpu "watch -n 1 nvidia-smi"
          tmux select-window -t monitor:1
          tmux attach-session -t monitor
        )

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
    atuin = {
      package = pkgs.unstable.atuin;
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
    file = {
      ".docker/docker-compose.yaml".source = ./docker-compose.yaml;
    };
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
      csakura
      pipes
      tty-clock
    ];
  };

  sops = {
    secrets = {
      "ssh/zenith".sopsFile = ./secrets.yaml;
      "ssh/gale".sopsFile = ./secrets.yaml;
      "ssh/pi".sopsFile = ./secrets.yaml;
      "docker/env" = {
        sopsFile = ./secrets.yaml;
        path = "${config.home.homeDirectory}/.docker/.env";
      };
    };
  };
}
