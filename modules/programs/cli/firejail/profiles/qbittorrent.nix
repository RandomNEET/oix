{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
pkgs.writeText "firejail-qbittorrent-profile" ''
  # Firejail profile for qbittorrent
  # Description: An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.cache/qBittorrent
  noblacklist ''${HOME}/.config/qBittorrent
  noblacklist ''${HOME}/.config/qBittorrentrc
  noblacklist ''${HOME}/.local/share/data/qBittorrent
  noblacklist ''${HOME}/.local/share/qBittorrent

  # Allow python (blacklisted by disable-interpreters.inc)
  include allow-python2.inc
  include allow-python3.inc

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-shell.inc

  whitelist ${DOWNLOADS}
  whitelist ''${HOME}/.cache/qBittorrent
  whitelist ''${HOME}/.config/qBittorrent
  whitelist ''${HOME}/.config/qBittorrentrc
  whitelist ''${HOME}/.local/share/data/qBittorrent
  whitelist ''${HOME}/.local/share/qBittorrent
  include whitelist-common.inc
  include whitelist-var-common.inc

  apparmor
  caps.drop all
  machine-id
  netfilter
  nodvd
  nogroups
  noinput
  nonewprivs
  noroot
  nosound
  notv
  nou2f
  novideo
  protocol unix,inet,inet6,netlink
  seccomp

  private-bin python*,qbittorrent
  private-dev
  #private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,resolv.conf,ssl,X11,xdg
  private-tmp

  # See https://github.com/netblue30/firejail/issues/3707 for tray-icon
  dbus-user none
  dbus-system none

  #memory-deny-write-execute # problems on Arch, see #1690 on GitHub repo
  restrict-namespaces
''
