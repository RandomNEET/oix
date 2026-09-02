{
  pkgs,
  global,
  ...
}:
let
  llm-agent-common-profile = import ./llm-agent-common.nix { inherit pkgs global; };
  local = pkgs.writeText "firejail-opencode-local" ''
    ignore blacklist ''${RUNUSER}
    ignore whitelist ''${RUNUSER}/openssh_agent
    whitelist /run/current-system/sw
    private-etc profiles
  '';
in
pkgs.writeText "firejail-opencode-profile" ''
  # Firejail profile for opencode
  # Description: The open source coding agent
  # This file is overwritten after every install/update
  quiet
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.cache/opencode
  noblacklist ''${HOME}/.config/opencode
  noblacklist ''${HOME}/.local/share/opencode
  noblacklist ''${HOME}/.local/state/opencode

  # Add the following lines to opencode.local to enable whitelisting in `''${HOME}`.
  #mkdir ''${HOME}/.cache/opencode
  #mkdir ''${HOME}/.config/opencode
  #mkdir ''${HOME}/.local/share/opencode
  #mkdir ''${HOME}/.local/state/opencode
  #whitelist ''${HOME}/.cache/opencode
  #whitelist ''${HOME}/.config/git
  #whitelist ''${HOME}/.config/opencode
  #whitelist ''${HOME}/.gitconfig
  #whitelist ''${HOME}/.local/share/opencode
  #whitelist ''${HOME}/.local/state/opencode
  #include whitelist-common.inc

  apparmor

  # Redirect
  include ${llm-agent-common-profile}
''
