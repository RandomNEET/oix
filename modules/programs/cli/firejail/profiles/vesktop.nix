{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
let
  discord-common-profile = import ./discord-common.nix { inherit pkgs DOWNLOADS; };
in
pkgs.writeText "firejail-vesktop-profile" ''
  # Firejail profile for vesktop
  # Description: A custom Discord client
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.config/vesktop

  whitelist ''${HOME}/.config/vesktop

  private-bin vesktop

  ignore join-or-start discord
  join-or-start vesktop

  # Redirect
  include ${discord-common-profile}
''
