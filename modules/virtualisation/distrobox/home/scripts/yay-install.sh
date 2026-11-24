#!/bin/sh
set -eu

if [ "$(id -u)" -eq 0 ]; then
	printf '%s\n' 'Run yay-install.sh as a regular container user; makepkg cannot run as root.' >&2
	exit 1
fi

if command -v yay >/dev/null 2>&1; then
	printf '%s\n' 'yay is already installed; skipping.'
	exit 0
fi

# Avoid partial upgrades
sudo -n pacman -Syu --needed --noconfirm base-devel git

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/yay-install.XXXXXXXX")
trap 'rm -rf -- "$build_dir"' 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

# Build as container user
git clone --depth 1 https://aur.archlinux.org/yay.git "$build_dir/yay"
cd "$build_dir/yay"
makepkg --syncdeps --install --needed --noconfirm
