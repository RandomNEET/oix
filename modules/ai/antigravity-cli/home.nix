# TODO: 配置目录移至~/.config内
{
  imports = [
    ../shared/mcp.nix
    ../shared/packages.nix
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
