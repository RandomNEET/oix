#!/bin/sh
set -eu

mirror_host=mirrors.ustc.edu.cn

if [ "$(id -u)" -ne 0 ]; then
	exec sudo sh "$0" "$@"
fi

mirrorlist=/etc/pacman.d/mirrorlist
if [ -f "$mirrorlist" ] && [ ! -e "$mirrorlist.bak" ]; then
	cp -p "$mirrorlist" "$mirrorlist.bak"
fi

# Keep pacman variables
# shellcheck disable=SC2016
printf 'Server = https://%s/archlinux/$repo/os/$arch\n' "$mirror_host" >"$mirrorlist"
