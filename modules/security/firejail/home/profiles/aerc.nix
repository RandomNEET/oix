{
  config,
  pkgs,
  global,
  DOCUMENTS,
  DOWNLOADS,
  ...
}:
let
  local = pkgs.writeText "firejail-aerc-local" ''
    # Maildir
    ignore mkdir ''${HOME}/.Mail
    ignore mkdir ''${HOME}/.mail
    ignore mkdir ''${HOME}/Mail
    ignore mkdir ''${HOME}/mail
    ignore mkdir ''${HOME}/postponed
    ignore mkdir ''${HOME}/sent
    mkdir ${config.accounts.email.maildirBasePath}
    noblacklist ${config.accounts.email.maildirBasePath}
    whitelist ${config.accounts.email.maildirBasePath}

    # Editors, terminal emulators and mail helpers
    noblacklist ''${HOME}/.config/nvim
    noblacklist ''${HOME}/.config/helix
    noblacklist ''${HOME}/.config/bat
    noblacklist ''${HOME}/.config/isyncrc
    noblacklist ''${HOME}/.config/kitty
    noblacklist ''${HOME}/.config/foot
    noblacklist ''${PATH}/foot
    noblacklist ''${PATH}/footclient
    noblacklist ''${PATH}/kitty
    whitelist ''${HOME}/.config/nvim
    whitelist ''${HOME}/.config/helix
    whitelist ''${HOME}/.config/bat
    whitelist ''${HOME}/.config/isyncrc
    whitelist ''${HOME}/.config/kitty
    whitelist ''${HOME}/.config/foot

    # Allow external viewers to connect to Wayland
    ignore blacklist ''${RUNUSER}/wayland-*

    # Use software rendering for GTK viewers while no3d is enabled
    env GSK_RENDERER=cairo
    env GDK_DISABLE=gl,vulkan
    # GTK Wayland viewers need memfd_create for shared-memory buffers
    ignore memory-deny-write-execute

    # Browser runtime directories
    noblacklist ''${RUNUSER}/qutebrowser
    noblacklist ''${RUNUSER}/*firefox*
    noblacklist ''${RUNUSER}/psd/*firefox*
    whitelist ''${RUNUSER}/qutebrowser
    whitelist ''${RUNUSER}/*firefox*
    whitelist ''${RUNUSER}/psd/*firefox*

    # Allow shell commands used by filters and hooks
    include allow-bin-sh.inc

    # Share temporary files with external viewers
    ignore private-tmp
  '';
in
pkgs.writeText "firejail-aerc-profile" ''
  # Firejail profile for aerc
  # Description: A pretty good email client that runs in your terminal
  # This file is overwritten after every install/update
  quiet
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  noblacklist ${DOCUMENTS}
  noblacklist ''${HOME}/.Mail
  noblacklist ''${HOME}/.bogofilter
  noblacklist ''${HOME}/.config/msmtp
  noblacklist ''${HOME}/.config/nano
  noblacklist ''${HOME}/.config/aerc
  noblacklist ''${HOME}/.local/state/aerc
  noblacklist ''${HOME}/.elinks
  noblacklist ''${HOME}/.emacs
  noblacklist ''${HOME}/.emacs.d
  noblacklist ''${HOME}/.gnupg
  noblacklist ''${HOME}/.mail
  noblacklist ''${HOME}/.mailcap
  noblacklist ''${HOME}/.msmtprc
  noblacklist ''${HOME}/.nanorc
  noblacklist ''${HOME}/.signature
  noblacklist ''${HOME}/.vim
  noblacklist ''${HOME}/.viminfo
  noblacklist ''${HOME}/.vimrc
  noblacklist ''${HOME}/.w3m
  noblacklist ''${HOME}/Mail
  noblacklist ''${HOME}/mail
  noblacklist ''${HOME}/postponed
  noblacklist ''${HOME}/sent
  noblacklist /etc/msmtprc
  noblacklist /var/mail
  noblacklist /var/spool/mail

  include allow-lua.inc

  blacklist ''${RUNUSER}/wayland-*

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-x11.inc
  include disable-xdg.inc

  mkdir ''${HOME}/.config/aerc
  mkdir ''${HOME}/.local/state/aerc
  mkdir ''${HOME}/.Mail
  mkdir ''${HOME}/.mail
  mkdir ''${HOME}/Mail
  mkdir ''${HOME}/mail
  mkdir ''${HOME}/postponed
  mkdir ''${HOME}/sent
  whitelist ${DOCUMENTS}
  whitelist ${DOWNLOADS}
  whitelist ''${HOME}/.Mail
  whitelist ''${HOME}/.bogofilter
  whitelist ''${HOME}/.config/msmtp
  whitelist ''${HOME}/.config/nano
  whitelist ''${HOME}/.config/aerc
  whitelist ''${HOME}/.local/state/aerc
  whitelist ''${HOME}/.elinks
  whitelist ''${HOME}/.emacs
  whitelist ''${HOME}/.emacs.d
  whitelist ''${HOME}/.gnupg
  whitelist ''${HOME}/.mail
  whitelist ''${HOME}/.mailcap
  whitelist ''${HOME}/.msmtprc
  whitelist ''${HOME}/.nanorc
  whitelist ''${HOME}/.signature
  whitelist ''${HOME}/.vim
  whitelist ''${HOME}/.viminfo
  whitelist ''${HOME}/.vimrc
  whitelist ''${HOME}/.w3m
  whitelist ''${HOME}/Mail
  whitelist ''${HOME}/mail
  whitelist ''${HOME}/postponed
  whitelist ''${HOME}/sent
  whitelist /usr/share/gnupg
  whitelist /usr/share/gnupg2
  whitelist /usr/share/aerc
  whitelist /var/mail
  whitelist /var/spool/mail
  include whitelist-common.inc
  include whitelist-runuser-common.inc
  include whitelist-usr-share-common.inc
  include whitelist-var-common.inc

  writable-run-user
  writable-var

  apparmor
  caps.drop all
  ipc-namespace
  machine-id
  netfilter
  no3d
  nodvd
  nogroups
  noinput
  nonewprivs
  noroot
  nosound
  notv
  nou2f
  novideo
  protocol unix,inet,inet6
  seccomp
  seccomp.block-secondary

  #disable-mnt
  private-cache
  private-dev
  private-etc @tls-ca,@x11,gnupg,host.conf,mail,mailname,msmtprc,nntpserver
  private-tmp

  dbus-user none
  dbus-system none

  memory-deny-write-execute
  read-only ''${HOME}/.signature
  restrict-namespaces
''
