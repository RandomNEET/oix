{
  imports = [
    ./sever
    ./microvm

    ../../modules/hardware/gpu

    ../../modules/storage/fstrim

    ../../modules/security/sops
    ../../modules/security/gpg
    ../../modules/security/password-store

    ../../modules/network/ssh
    ../../modules/network/mosh
    ../../modules/network/tailscale
    ../../modules/network/xray

    ../../modules/virtualisation/libvirtd
    ../../modules/virtualisation/docker

    ../../modules/shell

    ../../modules/development/git
    ../../modules/development/lazygit
    ../../modules/development/direnv

    ../../modules/editor/nixvim
    ../../modules/editor/helix

    ../../modules/file-manager/yazi

    ../../modules/browser/w3m

    ../../modules/media/mpd
    ../../modules/media/yt-dlp
    ../../modules/media/gallery-dl

    ../../modules/scripts/oix-init
    ../../modules/scripts/gen-diff
    ../../modules/scripts/nix-daemon-proxy
    ../../modules/scripts/tlmc

    ../../modules/appearance/themes
  ];
}
