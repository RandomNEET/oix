{ pkgs, ... }:
{
  fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { };
  obsidian-catppuccin = pkgs.callPackage ./obsidian-catppuccin { };
  obsidian-livesync = pkgs.callPackage ./obsidian-livesync { };
  obsidian-trash-explorer = pkgs.callPackage ./obsidian-trash-explorer { };
}
