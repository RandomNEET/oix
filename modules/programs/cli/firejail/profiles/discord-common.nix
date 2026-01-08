{ pkgs, DOWNLOADS, ... }:
let
  electron-common-profile = import ./electron-common.nix { inherit pkgs DOWNLOADS; };
in
pkgs.writeText "firejail-discord-common-profile" ''
  # Firejail profile for discord

  # Disabled until someone reported positive feedback
  ignore apparmor

  ignore noexec ''${HOME}
  ignore novideo

  whitelist ''${HOME}/.config/BetterDiscord
  whitelist ''${HOME}/.local/share/betterdiscordctl

  private-bin awk,bash,cut,echo,egrep,electron,electron[0-9],electron[0-9][0-9],env,fish,grep,head,sed,sh,tclsh,tr,which,xdg-mime,xdg-open,zsh
  private-etc @tls-ca

  # allow D-Bus notifications
  dbus-user filter
  dbus-user.talk org.freedesktop.Notifications
  ignore dbus-user none

  join-or-start discord

  # Redirect
  include ${electron-common-profile}
''
