{
  programs.nixvim = {
    autoCmd = [
      {
        event = "BufReadPost";
        pattern = "*";
        callback = {
          __raw = ''
            function()
              vim.schedule(function()
                if vim.wo.foldmethod ~= 'manual' and vim.wo.foldmethod ~= ''' then
                  return
                end
                
                vim.opt_local.foldmethod = 'expr'
                vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.opt_local.foldlevel = 99
              end)
            end
          '';
        };
      }

      {
        event = "FileType";
        pattern = "markdown";
        callback = {
          __raw = ''
            function()
              vim.opt_local.conceallevel = 1
            end
          '';
        };
      }
    ];
  };
}
