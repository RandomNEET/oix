{
  osConfig,
  lib,
  ...
}:
{
  imports = [
    ../shared/mcp.nix
    ../shared/packages.nix
  ]
  ++ lib.optional (osConfig.oix.appearance.themes.enable or false) {
    # TEMPFIX until Stylix uses cli.theme.name for OpenCode 2
    programs.opencode = {
      tui = lib.mkForce { };
      cli.theme.name = "stylix";
    };
  };

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    mutableSettings = true;
    settings = {
      update = "disable";
    };
    context = ../shared/context.md;
  };
}
// lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
  stylix.targets.opencode.enable = true;
}
