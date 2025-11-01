{
  programs.nixvim = {
    autoCmd = [
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
