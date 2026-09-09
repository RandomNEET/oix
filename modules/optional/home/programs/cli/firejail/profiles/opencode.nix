{
  pkgs,
  global,
  ...
}:
let
  llm-agent-common-profile = import ./llm-agent-common.nix { inherit pkgs global; };
  local = pkgs.writeText "firejail-opencode-local" ''
    # Allow access to the entire per-user runtime directory
    ignore blacklist ''${RUNUSER}
    ignore whitelist ''${RUNUSER}/openssh_agent

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
