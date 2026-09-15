{
  config,
  lib,
  mylib,
  ...
}:
let
  codexConfigPath =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/codex/config.toml"
    else
      "${config.home.homeDirectory}/.codex/config.toml";
  codexFileKey =
    if config.home.preferXdgDirectories then
      lib.removePrefix config.home.homeDirectory codexConfigPath
    else
      ".codex/config.toml";
in
{
  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      approval_policy = "on-request";
    };
  };

  home = mylib.util.mkMutableHomeFile {
    inherit config;
    hmLib = lib.hm;
    activationName = "make-codex-config-mutable";
    fileKey = codexFileKey;
    targetPath = codexConfigPath;
    mode = "0600";
  };
}
