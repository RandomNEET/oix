{
  lib,
  pkgs,
  prev,
}:
lib.mergeAttrsList [
  { fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { }; }
  {
    npmPackages = {
      obsidian-headless = pkgs.callPackage ./npm-packages/obsidian-headless { };
    };
  }
  {
    hyprlandPlugins = prev.hyprlandPlugins // {
      # hyprspace = (pkgs.callPackage ./hyprland-plugins { }).hyprspace;
    };
  }
  {
    obsidianPlugins = {
      # livesync = pkgs.callPackage ./obsidian-plugins/livesync { };
      trash-explorer = pkgs.callPackage ./obsidian-plugins/trash-explorer { };
    };
  }
  {
    tmuxPlugins = prev.tmuxPlugins // {
      # dotbar = (pkgs.callPackage ./tmux-plugins { }).dotbar;
    };
  }
]
