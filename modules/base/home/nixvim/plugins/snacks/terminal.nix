{
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
        key = "<leader>t";
        options = {
          desc = "Toggle terminal";
        };
      }
    ];
  };
}
