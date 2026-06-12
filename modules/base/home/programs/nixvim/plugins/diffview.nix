{
  programs.nixvim = {
    plugins.diffview = {
      enable = true;
      settings = {
        keymaps.disable_defaults = false;
      };
      lazyLoad = {
        enable = true;
        settings = {
          cmd = [
            "DiffviewOpen"
            "DiffviewClose"
            "DiffviewToggleFiles"
            "DiffviewFocusFiles"
            "DiffviewRefresh"
            "DiffviewFileHistory"
          ];
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>dvo";
        action = "<cmd>DiffviewOpen<cr>";
        options = {
          desc = "Open Diffview";
        };
      }
      {
        mode = "n";
        key = "<leader>dvc";
        action = "<cmd>DiffviewClose<cr>";
        options = {
          desc = "Close Diffview";
        };
      }
      {
        mode = "n";
        key = "<leader>dvh";
        action = "<cmd>DiffviewFileHistory<cr>";
        options = {
          desc = "File History";
        };
      }
    ];
  };
}
