{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      _:
      let
        docDir = lib.removePrefix "$HOME/" opts.xdg.userDirs.documents;
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
            communityPlugins = [
              {
                pkg = pkgs.obsidian-livesync;
                enable = true;
              }
              {
                pkg = pkgs.obsidian-trash-explorer;
                enable = true;
              }
            ];
            themes = [
              {
                pkg = pkgs.obsidian-catppuccin;
                enable = true;
              }
            ];
            appearance = {
              cssTheme = "Catppuccin";
              interfaceFontFamily = "JetBrainsMono Nerd Font";
              textFontFamily = "JetBrainsMono Nerd Font";
              monospaceFontFamily = "JetBrainsMono Nerd Font";
            };
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
