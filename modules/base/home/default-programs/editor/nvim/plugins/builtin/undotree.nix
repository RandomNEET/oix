{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      extraConfigLua = ''
        vim.cmd("packadd nvim.undotree")
      '';
      keymaps = [
        {
          mode = "n";
          key = "<leader>u";
          action = "<cmd>Undotree<cr>";
          options = {
            desc = "Open UndoTree";
          };
        }
      ];
    };
  });
}
