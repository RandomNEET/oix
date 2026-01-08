{
  pkgs,
  global,
  DOCUMENTS,
  DOWNLOADS,
  ...
}:
pkgs.writeText "firejail-zathrua-profile" ''
  # Firejail profile for zathura
  # Description: Document viewer with a minimalistic interface
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.config/zathura
  noblacklist ''${HOME}/.local/share/zathura
  noblacklist ${DOCUMENTS}
  noblacklist ${DOWNLOADS}

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-shell.inc
  include disable-write-mnt.inc
  include disable-xdg.inc

  whitelist /usr/share/doc
  whitelist /usr/share/zathura
  include whitelist-runuser-common.inc
  include whitelist-usr-share-common.inc
  include whitelist-var-common.inc

  apparmor
  caps.drop all
  machine-id
  net none
  nodvd
  nogroups
  noinput
  nonewprivs
  noroot
  nosound
  notv
  nou2f
  novideo
  protocol unix
  seccomp
  seccomp.block-secondary
  tracelog

  private-bin zathura
  private-cache
  private-dev
  private-etc
  # private-lib has problems on Debian 10
  #private-lib gcc/*/*/libgcc_s.so.*,gcc/*/*/libstdc++.so.*,libarchive.so.*,libdjvulibre.so.*,libgirara-gtk*,libpoppler-glib.so.*,libspectre.so.*,zathura
  private-tmp

  dbus-user none
  dbus-system none

  read-only ''${HOME}
  read-write ''${HOME}/.config/zathura
  read-write ''${HOME}/.local/share/zathura
  restrict-namespaces
''
