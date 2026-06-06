{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
let
  discord-common-profile = import ./discord-common.nix { inherit pkgs global DOWNLOADS; };
  local = pkgs.writeText "firejail-vesktop-local" "";
in
pkgs.writeText "firejail-vesktop-profile" ''
  # Firejail profile for vesktop
  # Description: A custom Discord client
  # This file is overwritten after every install/update
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  # Needed for the audio source picker to work
  ignore noexec /tmp

  noblacklist ''${HOME}/.config/vesktop

  mkdir ''${HOME}/.config/vesktop
  whitelist ''${HOME}/.config/vesktop

  private-bin vesktop

  # Needed for screen sharing to work
  dbus-user.talk org.freedesktop.portal.Desktop

  ignore join-or-start discord
  join-or-start vesktop

  # Redirect
  include ${discord-common-profile}
''
