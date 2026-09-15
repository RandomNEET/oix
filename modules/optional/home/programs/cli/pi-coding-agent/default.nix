{
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  piConfigDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/pi/agent"
    else
      "${config.home.homeDirectory}/.pi/agent";
  piSettingsFile = "${piConfigDir}/settings.json";
in
{
  programs.pi-coding-agent = {
    enable = true;
    configDir = piConfigDir;
    settings = {
      defaultProjectTrust = "ask";
      enableInstallTelemetry = false;
      packages = [
        "npm:pi-mcp-adapter"
        "npm:pi-web-access"
        "npm:pi-subagents"
      ];
    };
    extraPackages = with pkgs; [
      bun
      nodejs
      uv
    ];
  };

  home = mylib.util.mkMutableHomeFile {
    inherit config;
    hmLib = lib.hm;
    activationName = "make-pi-coding-agent-settings-mutable";
    fileKey = piSettingsFile;
    targetPath = piSettingsFile;
  };
}
