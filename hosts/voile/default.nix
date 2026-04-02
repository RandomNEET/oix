{
  imports = [
    ./selfhost.nix

    ../../modules/system/core
    ../../modules/system/sops

    ../../modules/hardware/gpu

    ../../modules/services/automount
    ../../modules/services/avahi
    ../../modules/services/cron
    ../../modules/services/fstrim
    ../../modules/services/mpd
    ../../modules/services/openssh
    ../../modules/services/tlp
    ../../modules/services/xray

    ../../modules/programs/cli/bash
    ../../modules/programs/cli/bat
    ../../modules/programs/cli/btop
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/eza
    ../../modules/programs/cli/fastfetch
    ../../modules/programs/cli/fd
    ../../modules/programs/cli/fzf
    ../../modules/programs/cli/git
    ../../modules/programs/cli/htop
    ../../modules/programs/cli/jq
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/man
    ../../modules/programs/cli/nh
    ../../modules/programs/cli/nix-index
    ../../modules/programs/cli/nixvim
    ../../modules/programs/cli/ripgrep
    ../../modules/programs/cli/ssh
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/trash-cli
    ../../modules/programs/cli/yazi
    ../../modules/programs/cli/yt-dlp
    ../../modules/programs/cli/zoxide
    ../../modules/programs/cli/zsh

    ../../modules/virtualisation/docker
    ../../modules/virtualisation/libvirtd

    ../../modules/scripts
  ];
}
