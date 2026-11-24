#!/bin/sh
set -eu

mirror_host=mirrors.ustc.edu.cn

if [ "$(id -u)" -ne 0 ]; then
	exec sudo sh "$0" "$@"
fi

# Preserve source settings
for source in /etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
	[ -f "$source" ] || continue
	if ! grep -Eq 'https?://(deb\.debian\.org|ftp\.debian\.org|security\.debian\.org|mirrors\.ustc\.edu\.cn)/debian(-security)?([/[:space:]]|$)' "$source"; then
		continue
	fi
	if [ ! -e "$source.bak" ]; then
		cp -p "$source" "$source.bak"
	fi
	sed -E -i \
		-e "s#(https?://)(deb\.debian\.org|ftp\.debian\.org|security\.debian\.org|mirrors\.ustc\.edu\.cn)/debian(-security)?([/[:space:]]|$)#\1${mirror_host}/debian\3\4#g" \
		"$source"
done
