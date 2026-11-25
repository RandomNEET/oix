{
  imports = [
    ../../modules/hardware/gpu
    ../../modules/hardware/multimedia
    ../../modules/hardware/power
    ../../modules/hardware/bluetooth

    ../../modules/storage/fstrim

    ../../modules/security/sops
    ../../modules/security/gpg
    ../../modules/security/password-store
    ../../modules/security/firejail

    ../../modules/network/ssh
    ../../modules/network/mosh
    # ../../modules/network/dae
    ../../modules/network/tailscale

    ../../modules/virtualisation/podman
    ../../modules/virtualisation/distrobox

    ../../modules/shell
    ../../modules/development

    ../../modules/editor/nvim
    ../../modules/editor/helix

    ../../modules/file-manager/yazi

    ../../modules/terminal/foot

    ../../modules/browser/qutebrowser
    ../../modules/browser/chromium
    ../../modules/browser/w3m

    ../../modules/ai/antigravity-cli
    ../../modules/ai/codex
    ../../modules/ai/opencode
    ../../modules/ai/pi-coding-agent

    ../../modules/media/mpv
    ../../modules/media/swayimg
    ../../modules/media/yt-dlp
    ../../modules/media/gallery-dl

    ../../modules/document/zathura

    ../../modules/mail/aerc
    ../../modules/mail/mbsync

    ../../modules/misc/newsboat
    ../../modules/misc/ttyper

    ../../modules/scripts/oix-init
    ../../modules/scripts/gen-diff
    ../../modules/scripts/nix-daemon-proxy
    ../../modules/scripts/tlmc

    ../../modules/appearance/fonts
    ../../modules/appearance/themes

    ../../modules/desktop/ly
    ../../modules/desktop/niri
  ];
}
