{
  imports = [
    ../../../shared/agents/mcp
    ../../../shared/agents/packages
  ];

  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    context = ../../../shared/agents/context.md;
  };
}
