{
  imports = [
    ../shared/home.nix
  ];

  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      context.fileName = [ "AGENTS.md" ];
    };
    context.AGENTS = ../shared/context.md;
  };
}
