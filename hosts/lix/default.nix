{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system/core
    ../../modules/system/fonts
    ../../modules/system/garbage-collect
    ../../modules/system/gpu
    ../../modules/system/impermanence
    ../../modules/system/secure-boot
    ../../modules/system/virtualisation

    ../../modules/services/automount
    ../../modules/services/blueman
    ../../modules/services/flatpak
    ../../modules/services/greetd
    ../../modules/services/kmonad
    ../../modules/services/mbsync
    ../../modules/services/mpd
    ../../modules/services/pipewire
    ../../modules/services/snapper
    ../../modules/services/ssh
    ../../modules/services/tlp
    ../../modules/services/proxy/dae

    ../../modules/programs/cli/aerc
    ../../modules/programs/cli/bash
    ../../modules/programs/cli/bat
    ../../modules/programs/cli/btop
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/eza
    ../../modules/programs/cli/fastfetch
    ../../modules/programs/cli/fzf
    ../../modules/programs/cli/gh
    ../../modules/programs/cli/git
    ../../modules/programs/cli/gpg
    ../../modules/programs/cli/htop
    ../../modules/programs/cli/jq
    ../../modules/programs/cli/lazygit
    ../../modules/programs/cli/mpv
    ../../modules/programs/cli/nixvim
    ../../modules/programs/cli/rbw
    ../../modules/programs/cli/rigprep
    ../../modules/programs/cli/rmpc
    ../../modules/programs/cli/spotify-player
    ../../modules/programs/cli/tmux
    ../../modules/programs/cli/trash-cli
    ../../modules/programs/cli/ttyper
    ../../modules/programs/cli/yazi
    ../../modules/programs/cli/zoxide
    ../../modules/programs/cli/zsh

    ../../modules/programs/gui/discord
    ../../modules/programs/gui/fcitx5
    ../../modules/programs/gui/firefox
    ../../modules/programs/gui/games
    ../../modules/programs/gui/kitty
    ../../modules/programs/gui/localsend
    ../../modules/programs/gui/obs-studio
    ../../modules/programs/gui/obsidian
    ../../modules/programs/gui/qutebrowser
    ../../modules/programs/gui/spicetify
    ../../modules/programs/gui/swayimg
    ../../modules/programs/gui/thunderbird
    ../../modules/programs/gui/vscode
    ../../modules/programs/gui/zathura

    ../../modules/scripts

    ../../modules/desktop
  ];
}
