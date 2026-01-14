{
  config,
  lib,
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
pkgs.writeText "firejail-qutebrowser-profile" ''
  # Firejail profile for qutebrowser
  # Description: Keyboard-driven, vim-like browser based on PyQt5
  # Persistent global definitions
  include ${global}

  # Allow to launch terminal
  noblacklist ''${PATH}/foot
  noblacklist ''${PATH}/footclient
  noblacklist ''${PATH}/kitty

  # Allow custom directory
  noblacklist ''${HOME}/repo
  whitelist ''${HOME}/repo

  noblacklist ''${HOME}/.cache/qutebrowser
  noblacklist ''${HOME}/.config/qutebrowser
  noblacklist ''${HOME}/.local/share/qutebrowser
  noblacklist ''${RUNUSER}/qutebrowser

  # Allow /bin/sh (blacklisted by disable-shell.inc)
  include allow-bin-sh.inc

  # Allow python (blacklisted by disable-interpreters.inc)
  include allow-python2.inc
  include allow-python3.inc

  ignore noexec ''${HOME}

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-shell.inc

  mkdir ''${HOME}/.cache/qutebrowser
  #mkdir ''${HOME}/.config/qutebrowser
  mkdir ''${HOME}/.local/share/qutebrowser
  mkdir ''${RUNUSER}/qutebrowser
  whitelist ${DOWNLOADS}
  whitelist ''${HOME}/.cache/qutebrowser
  whitelist ''${HOME}/.config/qutebrowser
  whitelist ''${HOME}/.local/share/qutebrowser
  whitelist ''${RUNUSER}/qutebrowser
  whitelist /usr/share/qutebrowser
  whitelist /run/current-system/sw/bin/cat # for wl-clipboard in vim
  include whitelist-common.inc
  include whitelist-run-common.inc
  include whitelist-runuser-common.inc
  include whitelist-usr-share-common.inc
  include whitelist-var-common.inc

  #apparmor # breaks userscripts under ''${HOME}, see #5639
  caps.drop all
  netfilter
  nodvd
  nonewprivs
  noroot
  notv
  protocol unix,inet,inet6,netlink
  # blacklisting of chroot system calls breaks qt webengine
  seccomp !chroot,!name_to_handle_at
  #tracelog

  disable-mnt
  private-cache
  private-dev
  private-etc @tls-ca,egl # added egl for hardware acceleration
  #private-tmp # for other programs to open html

  dbus-user filter
  # qutebrowser-qt6 uses a newer chrome version which uses the name 'chromium'
  # see https://github.com/qutebrowser/qutebrowser/issues/7431
  dbus-user.own org.mpris.MediaPlayer2.chromium.*
  dbus-user.own org.mpris.MediaPlayer2.qutebrowser.*
  dbus-user.talk org.freedesktop.Notifications

  # Added for userscripts/ime-off
  ${lib.optionalString (config.i18n.inputMethod.type == "fcitx5") "dbus-user.talk org.fcitx.Fcitx5"}

  # Add the next line to allow screen sharing under wayland.
  #dbus-user.talk org.freedesktop.portal.Desktop
  # Add the next line if screen sharing sharing still does not work
  # with the above lines (might depend on the portal implementation).
  #ignore noroot
  dbus-system none

  #restrict-namespaces
''
