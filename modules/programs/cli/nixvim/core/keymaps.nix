{
  programs.nixvim = {
    globals.mapleader = " "; # space
    keymaps = [
      # Essentials
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>noh<cr>";
        options = {
          desc = "Clear search highlights";
        };
      }

      # Better up/down (handles wrapped lines unless a count is given)
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
          desc = "Down";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
          desc = "Down";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
          desc = "Up";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
          desc = "Up";
        };
      }

      # Window navigation (Ctrl + hjkl)
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options = {
          remap = true;
          desc = "Go to Left Window";
        };
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options = {
          remap = true;
          desc = "Go to Lower Window";
        };
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options = {
          remap = true;
          desc = "Go to Upper Window";
        };
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options = {
          remap = true;
          desc = "Go to Right Window";
        };
      }

      # Resize window using <ctrl> arrow keys
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options = {
          desc = "Increase Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options = {
          desc = "Decrease Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {
          desc = "Decrease Window Width";
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {
          desc = "Increase Window Width";
        };
      }

      # Move Lines (Alt + jk)
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>execute 'move .+' . v:count1<cr>==";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "i";
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
        options = {
          desc = "Move Up";
        };
      }

      # Buffers management
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options = {
          desc = "Next Buffer";
        };
      }
      {
        mode = "n";
        key = "[b";
        action = "<cmd>bprevious<cr>";
        options = {
          desc = "Prev Buffer";
        };
      }
      {
        mode = "n";
        key = "]b";
        action = "<cmd>bnext<cr>";
        options = {
          desc = "Next Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bb";
        action = "<cmd>e #<cr>";
        options = {
          desc = "Switch to Other Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>`";
        action = "<cmd>e #<cr>";
        options = {
          desc = "Switch to Other Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bD";
        action = "<cmd>:bd<cr>";
        options = {
          desc = "Delete Buffer and Window";
        };
      }
    ];
  };
}
