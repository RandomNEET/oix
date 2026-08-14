{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      autoshare = false;
      autoupdate = true;
    };
    tui = {
      keybinds = {
        leader = "ctrl+x";
      };
    };
    extraPackages = with pkgs; [
      nodejs
      uv
    ];
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.opencode.enable = true;
}
