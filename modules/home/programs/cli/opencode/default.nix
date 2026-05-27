{ osConfig, lib, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      autoshare = false;
      autoupdate = true;
    };
    tui = {
      keybinds = {
        leader = "ctrl+x";
      };
    };
  };

  stylix.targets.opencode.enable = lib.mkIf osConfig.desktop.themes.enable true;
}
