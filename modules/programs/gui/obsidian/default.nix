{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
      let
        docDir =
          lib.replaceStrings [ "${config.home.homeDirectory}" "$HOME/" ] [ "" "" ]
            config.xdg.userDirs.documents;
      in
      {
        programs.obsidian = {
          enable = true;
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
              "tag-pane"
              "templates"
              "word-count"
            ];
            communityPlugins = import ./plugins.nix { inherit pkgs; };
          };
          vaults =
            opts.obsidian.vaults or {
              default = {
                enable = true;
                target = "${docDir}/notes";
              };
            };
        };
      }
    )
  ];
}
