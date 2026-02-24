{ pkgs, ... }:
{
  obsidianPlugins = {
    livesync = pkgs.callPackage ./livesync { };
    trash-explorer = pkgs.callPackage ./trash-explorer { };
  };
}
