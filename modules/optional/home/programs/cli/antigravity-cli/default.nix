{
  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      context.fileName = [ "AGENTS.md" ];
    };
    context.AGENTS = ./context.md;
  };
}
