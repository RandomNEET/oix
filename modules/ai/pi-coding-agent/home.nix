{
  config,
  lib,
  pkgs,
  ...
}:
let
  piConfigDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/pi/agent"
    else
      "${config.home.homeDirectory}/.pi/agent";

  # TEMPFIX until Home Manager merges Pi MCP integration in PR #10067
  mcpServers = lib.mapAttrs (
    name: server:
    lib.hm.mcp.transformMcpServer {
      inherit server;
      extraTransforms = [ (lib.hm.mcp.wrapEnvFilesCommand { inherit pkgs name; }) ];
    }
  ) config.programs.mcp.servers;
in
{
  imports = [
    ../shared/mcp.nix
    ../shared/packages.nix
  ];

  programs.pi-coding-agent = {
    enable = true;
    mutableSettings = true;
    configDir = piConfigDir;
    settings = {
      enableInstallTelemetry = false;
      packages = [
        "npm:pi-web-access"
        "npm:pi-subagents"
        "npm:pi-background-task"
        "npm:@narumitw/pi-plan-mode"
        "npm:@narumitw/pi-btw"
        "npm:@narumitw/pi-usage"
        "npm:pi-context-view"
      ];
    };
    context = ../shared/context.md;
  };

  # TEMPFIX until Home Manager merges Pi MCP integration in PR #10067
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json" =
    lib.mkIf (config.programs.pi-coding-agent.enable && config.programs.mcp.enable && mcpServers != { })
      {
        source = (pkgs.formats.json { }).generate "pi-mcp.json" { inherit mcpServers; };
      };
}
