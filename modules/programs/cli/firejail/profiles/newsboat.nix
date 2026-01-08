{ pkgs, global, ... }:
pkgs.writeText "firejail-newsboat-profile" ''
  # Firejail profile for Newsboat
  # Description: RSS program
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.config/newsbeuter
  noblacklist ''${HOME}/.config/newsboat
  noblacklist ''${HOME}/.local/share/newsbeuter
  noblacklist ''${HOME}/.local/share/newsboat
  noblacklist ''${HOME}/.newsbeuter
  noblacklist ''${HOME}/.newsboat
  noblacklist ''${HOME}/.w3m

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-xdg.inc

  whitelist ''${HOME}/.config/newsbeuter
  whitelist ''${HOME}/.config/newsboat
  whitelist ''${HOME}/.local/share/newsbeuter
  whitelist ''${HOME}/.local/share/newsboat
  whitelist ''${HOME}/.newsbeuter
  whitelist ''${HOME}/.newsboat
  whitelist ''${HOME}/.w3m
  include whitelist-common.inc
  include whitelist-runuser-common.inc
  include whitelist-var-common.inc

  caps.drop all
  ipc-namespace
  netfilter
  no3d
  nodvd
  nogroups
  noinput
  nonewprivs
  noroot
  notv
  nou2f
  novideo
  protocol inet,inet6
  seccomp

  disable-mnt
  private-bin gzip,lynx,newsboat,sh,w3m
  private-cache
  private-dev
  private-etc @tls-ca,lynx.cfg,lynx.lss,terminfo,profiles # added profiles
  private-tmp

  dbus-user none
  dbus-system none

  restrict-namespaces
''
