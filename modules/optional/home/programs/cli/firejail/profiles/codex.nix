{
  pkgs,
  global,
  ...
}:
let
  llm-agent-common-profile = import ./llm-agent-common.nix { inherit pkgs global; };
  local = pkgs.writeText "firejail-codex-local" ''
    # Allow access to the entire per-user runtime directory
    ignore blacklist ''${RUNUSER}
    ignore whitelist ''${RUNUSER}/openssh_agent

    # Allow Codex to create its nested bubblewrap sandbox
    ignore seccomp
    ignore seccomp.block-secondary
    ignore restrict-namespaces

    # Allow bubblewrap to read the kernel overflow UID/GID settings
    noblacklist /proc/sys/kernel/overflowuid
    noblacklist /proc/sys/kernel/overflowgid

    # Expose system-wide NixOS executables and the required PAM profiles
    whitelist /run/current-system/sw
    private-etc profiles

    # Replace the global blacklist with a path-specific exception policy
    ignore blacklist ''${HOME}/.config/sops-nix

    # Keep the secrets directory reachable while hiding all other sops-nix data
    noblacklist ''${HOME}/.config/sops-nix/secrets
    blacklist ''${HOME}/.config/sops-nix/*

    # Expose only the MCP secret and hide all sibling secrets
    noblacklist ''${HOME}/.config/sops-nix/secrets/mcp
    blacklist ''${HOME}/.config/sops-nix/secrets/*

    # Allow the agent to read the MCP secret without modifying it
    read-only ''${HOME}/.config/sops-nix/secrets/mcp
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
