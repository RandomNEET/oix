{
  imports = [
    ../../../shared/agents/mcp
    ../../../shared/agents/packages
  ];

  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      context.fileName = [ "AGENTS.md" ];
    };
    context.AGENTS = ../../../shared/agents/context.md;
  };
}
