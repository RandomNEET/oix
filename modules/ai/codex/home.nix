{
  imports = [
    ../shared/home.nix
  ];

  programs.codex = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    context = ../shared/context.md;
  };
}
