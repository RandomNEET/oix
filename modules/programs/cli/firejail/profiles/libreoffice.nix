{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
pkgs.writeText "firejail-libreoffice-profile" ''
  # Firejail profile for libreoffice
  # Description: Office productivity suite
  # Persistent global definitions
  include ${global}

  noblacklist /usr/local/sbin
  noblacklist ''${HOME}/.config/libreoffice
  noblacklist ${DOWNLOADS}

  # libreoffice can sign documents with GPG
  noblacklist ''${HOME}/.gnupg
  read-only ''${HOME}/.gnupg/trustdb.gpg
  read-only ''${HOME}/.gnupg/pubring.kbx
  blacklist ''${HOME}/.gnupg/crls.d
  blacklist ''${HOME}/.gnupg/openpgp-revocs.d
  blacklist ''${HOME}/.gnupg/private-keys-v1.d
  blacklist ''${HOME}/.gnupg/pubring.kbx~
  blacklist ''${HOME}/.gnupg/random_seed

  # libreoffice uses java for some functionality.
  # Add 'ignore include allow-java.inc' to your libreoffice.local if you don't need that functionality.
  # Allow java (blacklisted by disable-devel.inc)
  include allow-java.inc

  # added for themes
  noblacklist ''${HOME}/.config/gtk-3.0
  noblacklist ''${HOME}/.config/gtk-4.0
  noblacklist ''${HOME}/.config/dconf
  whitelist ''${HOME}/.config/dconf
  whitelist ''${HOME}/.config/gtk-3.0
  whitelist ''${HOME}/.config/gtk-4.0

  blacklist /usr/libexec

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-programs.inc

  include whitelist-run-common.inc
  include whitelist-var-common.inc

  # Debian 10/Ubuntu 18.04 come with their own apparmor profile, but it is not in enforce mode.
  # Add the next lines to your libreoffice.local to use the Ubuntu profile instead of firejail's apparmor profile.
  #ignore apparmor
  #ignore nonewprivs
  #ignore protocol
  #ignore seccomp
  #ignore tracelog

  apparmor
  caps.drop all
  netfilter
  nodvd
  nogroups
  noinput
  nonewprivs
  noroot
  notv
  nou2f
  novideo
  protocol unix,inet,inet6
  seccomp
  tracelog

  #private-bin libreoffice,sh,uname,dirname,grep,sed,basename,ls
  private-cache
  private-dev
  private-etc @tls-ca,@x11,cups,gnupg,libreoffice,papersize,ssh,profiles # added profiles
  private-tmp

  # added for themes
  dbus-user filter
  dbus-user.talk org.freedesktop.portal.Desktop
  dbus-user.talk org.gnome.desktop.interface

  dbus-system none

  restrict-namespaces
  join-or-start libreoffice
''
