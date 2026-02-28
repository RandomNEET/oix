{
  lib,
  pkgs,
  prev,
}:
lib.mergeAttrsList [
  { fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { }; }
  {
    hyprlandPlugins = prev.hyprlandPlugins // {
      hyprspace = (pkgs.callPackage ./hyprland-plugins { }).hyprspace;
    };
  }
  (import ./obsidian-plugins { inherit pkgs; })
  {
    tmuxPlugins = prev.tmuxPlugins // {
      dotbar = (pkgs.callPackage ./tmux-plugins { }).dotbar;
    };
  }
]
