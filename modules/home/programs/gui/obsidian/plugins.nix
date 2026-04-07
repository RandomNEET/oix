{ pkgs, ... }:
[
  {
    pkg = pkgs.obsidianPlugins.livesync;
    enable = true;
  }
  {
    pkg = pkgs.obsidianPlugins.trash-explorer;
    enable = true;
  }
]
