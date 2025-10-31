{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/core
    ../../modules/system/docker
    ../../modules/system/garbage-collect
    ../../modules/system/gpu
    ../../modules/system/virtualisation

    ../../modules/services/automount
    ../../modules/services/calibre-web
    ../../modules/services/cron
    ../../modules/services/freshrss
    ../../modules/services/frp
    ../../modules/services/glances
    ../../modules/services/homepage-dashboard
    ../../modules/services/jellyfin
    ../../modules/services/mpd
    ../../modules/services/qbittorrent
    ../../modules/services/samba
    ../../modules/services/ssh
    ../../modules/services/vaultwarden
    ../../modules/services/proxy/xray

    ../../modules/programs/cli/bash
    ../../modules/programs/cli/bat
    ../../modules/programs/cli/btop
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/eza
    ../../modules/programs/cli/fastfetch
    ../../modules/programs/cli/fzf
    ../../modules/programs/cli/git
    ../../modules/programs/cli/htop
    ../../modules/programs/cli/jq
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/nixvim
    ../../modules/programs/cli/rigprep
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/trash-cli
    ../../modules/programs/cli/yazi
    ../../modules/programs/cli/zoxide
    ../../modules/programs/cli/zsh
    ../../modules/programs/cli/no-config/archive
    ../../modules/programs/cli/no-config/rice

    ../../modules/scripts
  ];

  environment.systemPackages = with pkgs; [
    iptables
    xray
  ];

  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [
        flac
        qq
      ];
    })
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:07:0:0";
    amdgpuBusId = "PCI:01:0:0";
  };

  systemd.services = {
    xray = {
      after = [
        "network.target"
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
    jellyfin = {
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
    homepage-dashboard = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
