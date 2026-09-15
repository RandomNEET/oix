{ config, lib, ... }:
let
  codexConfigKey =
    if config.home.preferXdgDirectories then
      "${lib.removePrefix config.home.homeDirectory config.xdg.configHome}/codex/config.toml"
    else
      ".codex/config.toml";
  codexConfigTarget = lib.removePrefix "/" codexConfigKey;
  codexConfigPath = "${config.home.homeDirectory}/${codexConfigTarget}";
in
{
  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      tui = {
        vim_mode_default = true;
      };
    };
  };

  # mutable config.toml
  home = {
    file."${codexConfigKey}" = {
      force = true;
      target = codexConfigTarget;
    };
    activation.makeCodexConfigMutable = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      target=${lib.escapeShellArg codexConfigPath}
      temporary="$target.home-manager-tmp"

      if [ -L "$target" ]; then
        run cp -L -- "$target" "$temporary"
        run chmod 0600 -- "$temporary"
        run mv -f -- "$temporary" "$target"
      fi
    '';
  };
}
