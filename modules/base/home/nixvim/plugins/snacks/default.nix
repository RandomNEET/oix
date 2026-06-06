{ mylib, ... }:
{
  imports = mylib.util.scanPaths ./. {
    types = [ "regular" ];
    extension = ".nix";
    exclude = [ "default.nix" ];
    depth = 1;
  };
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        bigfile = {
          enabled = true;
        };
        input = {
          enabled = true;
        };
        notifier = {
          enabled = true;
          border = "rounded";
        };
        quickfile = {
          enabled = true;
        };
        scope = {
          enabled = true;
        };
        scroll = {
          enabled = true;
        };
        statuscolumn = {
          enabled = true;
        };
        words = {
          enabled = true;
        };
      };
    };
    keymaps = [
      # Buffers
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua require('snacks').bufdelete()<cr>";
        options = {
          desc = "Delete Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>lua require('snacks').bufdelete.other()<cr>";
        options = {
          desc = "Delete Other Buffers";
        };
      }
    ];
  };
}
