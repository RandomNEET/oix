{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = lib.mkIf config.programs.obsidian.enable {
    plugins.obsidian = {
      enable = true;
      settings = {
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
        sync = {
          enabled = true;
          configs = config.lib.nixvim.mkRaw "{}";
        };
        legacy_commands = false;
      };
      lazyLoad = {
        enable = true;
        settings = {
          cmd = "Obsidian";
        };
      };
    };
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
      {
        mode = "n";
        action = "<cmd>Obsidian toggle_checkbox<cr>";
        key = "<leader>obc";
        options = {
          desc = "Cycle through checkbox options";
        };
      }
    ];
    extraPackages = with pkgs; [
      # First-time setup for obsidian-headless (required by Obsidian sync):
      #   1. ob login                          # authenticate with your Obsidian account
      #   2. cd into the target vault, then in an nvim terminal run:
      #      ob sync-setup --vault <vault>     # link the local vault to a remote one
      # Afterwards, just use :Obsidian sync for daily syncing.
      obsidian-headless
    ];
  };
}
