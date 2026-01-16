{
  programs.nixvim = {
    globals.mapleader = " "; # space
    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>noh<cr>";
        options = {
          desc = "Clear search highlights";
        };
      }
      # Window navigation
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-k>";
        action = "<cmd>wincmd k<cr>";
        options = {
          desc = "Cycle to top window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-j>";
        action = "<cmd>wincmd j<cr>";
        options = {
          desc = "Cycle to bottom window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-l>";
        action = "<cmd>wincmd l<cr>";
        options = {
          desc = "Cycle to right window";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-h>";
        action = "<cmd>wincmd h<cr>";
        options = {
          desc = "Cycle to left window";
        };
      }
      # Buffer
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete buffer";
        };
      }
      # Move text up and down
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options = {
          desc = "Move text up";
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options = {
          desc = "Move text down";
        };
      }
      {
        mode = [
          "v"
          "x"
        ];
        key = "<A-k>";
        action = "<cmd>m '<-2<cr>gv=gv";
        options = {
          desc = "Move text up";
        };
      }
      {
        mode = [
          "v"
          "x"
        ];
        key = "<A-j>";
        action = "<cmd>m '>+1<cr>gv=gv";
        options = {
          desc = "Move text down";
        };
      }
      {
        mode = "x";
        key = "K";
        action = "<cmd>m '<-2<cr>gv=gv";
        options = {
          desc = "Move text up";
        };
      }
      {
        mode = "x";
        key = "J";
        action = "<cmd>m '>+1<cr>gv=gv";
        options = {
          desc = "Move text down";
        };
      }
    ];
  };
}
