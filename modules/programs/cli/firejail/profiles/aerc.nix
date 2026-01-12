{
  config,
  pkgs,
  opts,
  global,
  DOCUMENTS,
  DOWNLOADS,
  ...
}:
let
  username = opts.users.primary.name;
in
pkgs.writeText "firejail-aerc-profile" ''
  # Firejail profile for aerc
  # Description: A pretty good email client that runs in your terminal
  quiet
  # Persistent global definitions
  include ${global}

  noblacklist ${config.accounts.email.maildirBasePath}
  noblacklist ${DOCUMENTS}
  noblacklist ''${HOME}/.bogofilter
  noblacklist ''${HOME}/.config/aerc
  noblacklist ''${HOME}/.config/nvim
  noblacklist ''${HOME}/.config/nano
  noblacklist ''${HOME}/.config/bat
  noblacklist ''${HOME}/.config/msmtp
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
  noblacklist ''${RUNUSER}/qutebrowser
  noblacklist ''${RUNUSER}/*firefox*
  noblacklist ''${RUNUSER}/psd/*firefox*
  noblacklist /etc/msmtprc
  noblacklist /var/mail
  noblacklist /var/spool/mail

  noblacklist ''${PATH}/foot
  noblacklist ''${PATH}/footclient
  noblacklist ''${PATH}/kitty

  include allow-bin-sh.inc

  include disable-common.inc
  include disable-devel.inc
  include disable-exec.inc
  include disable-interpreters.inc
  include disable-programs.inc
  include disable-x11.inc
  include disable-xdg.inc

  whitelist ${DOCUMENTS}
  whitelist ${DOWNLOADS}
  whitelist ${config.accounts.email.maildirBasePath}
  whitelist ''${HOME}/.bogofilter
  whitelist ''${HOME}/.config/aerc
  whitelist ''${HOME}/.config/nvim
  whitelist ''${HOME}/.config/nano
  whitelist ''${HOME}/.config/bat
  whitelist ''${HOME}/.config/msmtp
  whitelist ''${HOME}/.local/state/aerc
  whitelist ''${HOME}/.elinks
  whitelist ''${HOME}/.emacs
  whitelist ''${HOME}/.emacs.d
  whitelist ''${HOME}/.gnupg
  whitelist ''${HOME}/.mailcap
  whitelist ''${HOME}/.msmtprc
  whitelist ''${HOME}/.nanorc
  whitelist ''${HOME}/.signature
  whitelist ''${HOME}/.vim
  whitelist ''${HOME}/.viminfo
  whitelist ''${HOME}/.vimrc
  whitelist ''${HOME}/.w3m
  whitelist ''${RUNUSER}/qutebrowser
  whitelist ''${RUNUSER}/*firefox*
  whitelist ''${RUNUSER}/psd/*firefox*
  whitelist /usr/share/gnupg
  whitelist /usr/share/gnupg2
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
  tracelog

  #disable-mnt
  private-cache
  private-dev
  private-etc @tls-ca,@x11,gnupg,host.conf,mail,mailname,msmtprc,nntpserver,profiles/per-user/${username}/bin/nvim,profiles/per-user/${username}/bin/qutebrowser,profiles/per-user/${username}/bin/firefox,profiles/per-user/${username}/bin/swayimg,profiles/per-user/${username}/bin/zathura,profiles/per-user/${username}/bin/thunderbird
  #private-tmp # to open in browser

  dbus-user none
  dbus-system none

  read-only ''${HOME}/.signature
  restrict-namespaces
''
