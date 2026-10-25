{ config, pkgs, ... }:
let
  piConfigDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/pi/agent"
    else
      "${config.home.homeDirectory}/.pi/agent";
in
{
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
    extraPackages = with pkgs; [
      bun
      nodejs
      uv
    ];
  };
}
