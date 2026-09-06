{
  pkgs,
  global,
  ...
}:
let
  llm-agent-common-profile = import ./llm-agent-common.nix { inherit pkgs global; };
  local = pkgs.writeText "firejail-codex-local" ''
    ignore blacklist ''${RUNUSER}
    ignore whitelist ''${RUNUSER}/openssh_agent
    whitelist /run/current-system/sw
    private-etc profiles
  '';
in
pkgs.writeText "firejail-codex-profile" ''
  # Firejail profile for codex
  # Description: AI Coding Partner from OpenAI
  # This file is overwritten after every install/update
  quiet
  # Persistent local customizations
  include ${local}
  # Persistent global definitions
  include ${global}

  noblacklist ''${HOME}/.codex
  noblacklist ''${HOME}/.config/codex

  # Add the following lines to codex.local to enable whitelisting in `''${HOME}`.
  #mkdir ''${HOME}/.codex
  #mkdir ''${HOME}/.config/codex
  #whitelist ''${HOME}/.codex
  #whitelist ''${HOME}/.config/codex
  #whitelist ''${HOME}/.config/git
  #whitelist ''${HOME}/.gitconfig
  #include whitelist-common.inc

  apparmor

  # Redirect
  include ${llm-agent-common-profile}
''
