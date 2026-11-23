{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      plugins.snacks.settings.terminal = {
        enabled = true;
        win = {
          position = "bottom";
          height = 0.4;
          wo = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
          };
        };
      };
      keymaps = [
        {
          mode = "n";
          action = "<cmd>lua require('snacks').terminal.toggle()<cr>";
          key = "<leader>tt";
          options = {
            desc = "Toggle Terminal";
          };
        }
      ];
    };
  });
}
