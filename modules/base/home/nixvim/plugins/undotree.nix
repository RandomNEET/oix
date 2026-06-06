{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>u";
        action.__raw = ''
          function()
            if not package.loaded["undotree"] then
              vim.cmd("packadd nvim.undotree")
            end
            require("undotree").open()
          end
        '';
        options = {
          desc = "Open UndoTree";
        };
      }
    ];
  };
}
