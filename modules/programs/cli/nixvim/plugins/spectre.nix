{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>S";
        action = "<cmd>lua require('spectre').toggle()<cr>";
        options = {
          desc = "Toggle Spectre";
        };
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = "<leader>sw', '<cmd>lua require('spectre').open_visual({select_word=true})<cr>";
        options = {
          desc = "Search current word";
        };
      }
      {
        mode = "v";
        key = "<leader>sw";
        action = "'<leader>sp', '<cmd>lua require('spectre').open_file_search({select_word=true})<cr>";
        options = {
          desc = "Search current word";
        };
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "leader>sp', '<cmd>lua require('spectre').open_file_search({select_word=true})<cr>";
        options = {
          desc = "Search on current file";
        };
      }
    ];
    plugins.spectre = {
      enable = true;
      settings = {
        default = {
          find = {
            cmd = "rg";
            options = [
              "word"
              "hidden"
            ];
          };
          replace = {
            cmd = "sed";
          };
        };
        find_engine = {
          rg = {
            args = [
              "--color=never"
              "--no-heading"
              "--with-filename"
              "--line-number"
              "--column"
            ];
            cmd = "rg";
            options = {
              hidden = {
                desc = "hidden file";
                icon = "[H]";
                value = "--hidden";
              };
              ignore-case = {
                desc = "ignore case";
                icon = "[I]";
                value = "--ignore-case";
              };
              line = {
                desc = "match in line";
                icon = "[L]";
                value = "-x";
              };
              word = {
                desc = "match in word";
                icon = "[W]";
                value = "-w";
              };
            };
          };
        };
        is_insert_mode = false;
        live_update = true;
      };
    };
  };
}
