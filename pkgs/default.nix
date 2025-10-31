{ pkgs, ... }:
{
  obsidian-catppuccin = pkgs.callPackage ./obsidian-catppuccin { };
  obsidian-livesync = pkgs.callPackage ./obsidian-livesync { };
  obsidian-trash-explorer = pkgs.callPackage ./obsidian-trash-explorer { };
}
