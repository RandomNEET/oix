{
  imports = [
    ../shared/mcp.nix
    ../shared/packages.nix
  ];

  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    context = ../shared/context.md;
  };
}
