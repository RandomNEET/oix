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

  stylix.targets.opencode.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
