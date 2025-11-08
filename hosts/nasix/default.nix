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

    ../../modules/scripts
  ];
}
