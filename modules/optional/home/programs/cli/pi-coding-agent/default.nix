{ config, ... }:
let
  piConfigDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/pi/agent"
    else
      "${config.home.homeDirectory}/.pi/agent";
in
{
  imports = [
    ../../../shared/agents/mcp
    ../../../shared/agents/packages
  ];

  programs.pi-coding-agent = {
    enable = true;
    mutableSettings = true;
    configDir = piConfigDir;
    settings = {
      enableInstallTelemetry = false;
      packages = [
        "npm:pi-mcp-adapter"
        "npm:pi-web-access"
        "npm:pi-subagents"
      ];
    };
    context = ../../../shared/agents/context.md;
  };
}
