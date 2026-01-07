{ pkgs, ... }:
{
  fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { };
  obsidian-livesync = pkgs.callPackage ./obsidian-livesync { };
  obsidian-trash-explorer = pkgs.callPackage ./obsidian-trash-explorer { };
}
