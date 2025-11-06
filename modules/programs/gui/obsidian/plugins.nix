{ pkgs, ... }:
[
  {
    pkg = pkgs.obsidian-livesync;
    enable = true;
  }
  {
    pkg = pkgs.obsidian-trash-explorer;
    enable = true;
  }
]
