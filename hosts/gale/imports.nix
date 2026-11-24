{
  imports = [
    ../../modules/hardware/gpu
    ../../modules/hardware/display
    ../../modules/hardware/multimedia
    ../../modules/hardware/power
    ../../modules/hardware/bluetooth
    ../../modules/hardware/kmonad

    ../../modules/storage/impermanence
    ../../modules/storage/fstrim

    ../../modules/security/secure-boot
    ../../modules/security/sops
    ../../modules/security/gpg
    ../../modules/security/password-store
    ../../modules/security/firejail

    ../../modules/network/ssh
    ../../modules/network/mosh
    ../../modules/network/dae
    ../../modules/network/tailscale

    ../../modules/virtualisation/libvirtd
    ../../modules/virtualisation/podman
    ../../modules/virtualisation/distrobox

    ../../modules/desktop/niri
    ../../modules/desktop/hyprland
    ../../modules/desktop/mango

    ../../modules/shell
    ../../modules/development

    ../../modules/editor/nvim
    ../../modules/editor/helix
    ../../modules/editor/vscode

    ../../modules/file-manager/yazi

    ../../modules/terminal/foot
    ../../modules/terminal/kitty

    ../../modules/browser/qutebrowser
    ../../modules/browser/chromium
    ../../modules/browser/w3m

    ../../modules/ai/antigravity-cli
    ../../modules/ai/codex
    ../../modules/ai/opencode
    ../../modules/ai/pi-coding-agent

    ../../modules/media/mpv
    ../../modules/media/swayimg
    ../../modules/media/obs-studio
    ../../modules/media/mpd
    ../../modules/media/rmpc
    ../../modules/media/go-musicfox
    ../../modules/media/cava
    ../../modules/media/yt-dlp
    ../../modules/media/gallery-dl

    ../../modules/document/obsidian
    ../../modules/document/zathura

    ../../modules/mail/aerc
    ../../modules/mail/mbsync

    ../../modules/gaming/steam
    ../../modules/gaming/gamescope

    ../../modules/misc/newsboat
    ../../modules/misc/ttyper

    ../../modules/scripts/oix-init
    ../../modules/scripts/gen-diff
    ../../modules/scripts/nix-daemon-proxy
    ../../modules/scripts/snapper-list
    ../../modules/scripts/tlmc
  ];
}
