{
  config,
  lib,
  pkgs,
}:
lib.mergeAttrsList [
  { fcitx5-rime-ice = pkgs.callPackage ./fcitx5-rime-ice { }; }
  (import ./obsidian-plugins { inherit pkgs; })
]
