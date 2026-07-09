{ osConfig, lib, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      autoshare = false;
      autoupdate = true;
      mcp = {
        nixos = {
          type = "local";
          command = [
            "nix"
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
      };
    };
    tui = {
      keybinds = {
        leader = "ctrl+x";
      };
    };
  };
}
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.opencode.enable = true;
}
