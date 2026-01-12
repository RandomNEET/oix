{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.obsidian.enable {
    keymaps = [
      {
        mode = "n";
        action = "<cmd>Obsidian new<cr>";
        key = "<leader>obn";
        options = {
          desc = "New note";
        };
      }
      {
        mode = "n";
        action = "<cmd>Obsidian quick_switch<cr>";
        key = "<leader>obq";
        options = {
          desc = "Quick switch note";
        };
      }
      {
        mode = "n";
        action = "<cmd>Obsidian search<cr>";
        key = "<leader>obs";
        options = {
          desc = "Search notes";
        };
      }
      {
        mode = "n";
        action = "<cmd>Obsidian workspace<cr>";
        key = "<leader>obw";
        options = {
          desc = "Workspace switch";
        };
      }
      {
        mode = "n";
        action = "<cmd>Obsidian rename<cr>";
        key = "<leader>obr";
        options = {
          desc = "Rename note";
        };
      }
    ];
    plugins = {
      obsidian = {
        enable = true;
        settings = {
          completion = {
            min_chars = 2;
            blink = true;
          };
          new_notes_location = "current_dir";
          workspaces =
            let
              vaults = config.programs.obsidian.vaults;
              enabledVaults = lib.filterAttrs (name: value: value.enable or true) vaults;
            in
            lib.mapAttrsToList (name: value: {
              inherit name;
              path = "~/${value.target}";
            }) enabledVaults;
          picker = {
            name = "snacks.pick";
          };
          legacy_commands = false;
        };
      };
    };
  };
}
