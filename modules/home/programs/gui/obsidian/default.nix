{ pkgs, ... }:
{
  programs.obsidian = {
    enable = true;
    cli.enable = true;
    defaultSettings = {
      app = {
        vimMode = true;
        trashOption = "local";
      };
      corePlugins = [
        "backlink"
        "bookmarks"
        "canvas"
        "command-palette"
        "daily-notes"
        "editor-status"
        "file-explorer"
        "file-recovery"
        "global-search"
        "graph"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "switcher"
        "sync"
        "tag-pane"
        "templates"
        "word-count"
      ];
      communityPlugins = import ./plugins.nix { inherit pkgs; };
    };
  };
  home.packages = with pkgs; [ npmPackages.obsidian-headless ];
}
