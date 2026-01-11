{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        action = "<cmd>lua require('persistence').load()<cr>";
        key = "<leader>qs";
        options = {
          desc = "Load the session for the current directory";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('persistence').select()<cr>";
        key = "<leader>qS";
        options = {
          desc = "Select a session to load";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('persistence').load({ last = true })<cr>";
        key = "<leader>ql";
        options = {
          desc = "Load the last session";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('persistence').stop()<cr>";
        key = "<leader>qd";
        options = {
          desc = "Stop persistence";
        };
      }
    ];
    plugins.persistence = {
      enable = true;
      settings = {
        dir.__raw = ''vim.fn.stdpath("state") .. "/sessions/"'';
        need = 1;
        branch = true;
      };
    };
  };
}
