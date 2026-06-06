{
  pkgs,
  global,
  DOWNLOADS,
  ...
}:
let
  chromium-common-profile = import ./chromium-common.nix { inherit pkgs global DOWNLOADS; };
  local = pkgs.writeText "firejail-chromium-local" "";
in
pkgs.writeText "firejail-chromium-profile" ''
  # Firejail profile for chromium
  # Description: A web browser built for speed, simplicity, and security
  # This file is overwritten after every install/update
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.cache/chromium
  noblacklist ''${HOME}/.config/chromium
  noblacklist ''${HOME}/.config/chromium-flags.conf

  mkdir ''${HOME}/.cache/chromium
  mkdir ''${HOME}/.config/chromium
  whitelist ''${HOME}/.cache/chromium
  whitelist ''${HOME}/.config/chromium
  whitelist ''${HOME}/.config/chromium-flags.conf
  whitelist /usr/share/chromium

  #private-bin chromium,chromium-browser,chromedriver

  # Redirect
  include ${chromium-common-profile}
''
