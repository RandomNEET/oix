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
          lib.replaceStrings [ "${osConfig.users.users.${opts.users.primary.name}.home}" "$HOME/" ] [ "" "" ]
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
            appearance = {
              interfaceFontFamily = "JetBrainsMono Nerd Font";
              textFontFamily = "JetBrainsMono Nerd Font";
              monospaceFontFamily = "JetBrainsMono Nerd Font";
            };
          }
          // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
            appearance = {
              cssTheme = "Catppuccin";
            };
            themes = [
              {
                pkg = pkgs.obsidian-catppuccin;
                enable = true;
              }
            ];
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
