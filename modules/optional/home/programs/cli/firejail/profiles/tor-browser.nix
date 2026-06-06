{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
let
  firefox-common-profile = import ./firefox-common.nix { inherit pkgs global DOWNLOADS; };
  local = pkgs.writeText "firejail-tor-browser-local" "";
in
pkgs.writeText "firejail-tor-browser-profile" ''
  # Firejail profile for torbrowser
  # Description: Privacy-focused browser routing traffic through the Tor network
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  ignore dbus-user none

  noblacklist ''${HOME}/.tor project
  noblacklist ''${HOME}/.cache/tor project

  blacklist /sys/class/net
  blacklist /usr/libexec

  mkdir ''${HOME}/.tor project
  mkdir ''${HOME}/.cache/tor project
  whitelist ''${HOME}/.tor project
  whitelist ''${HOME}/.cache/tor project
  include whitelist-usr-share-common.inc

  dbus-user filter
  dbus-user.own org.mozilla.torbrowser.*

  include ${firefox-common-profile}
''
