{
  programs.nixvim = {
    plugins.snacks.settings.explorer = {
      enabled = true;
      replace_netrw = true;
      trash = true;
    };
    keymaps = [
      {
        mode = "n";
        action = "<cmd>lua require('snacks').explorer()<cr>";
        key = "<leader>e";
        options = {
          desc = "File explorer";
        };
      }
    ];
  };
}
