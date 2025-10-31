{ ... }:
{
  programs.nixvim = {
    keymaps = [
      # Window navigation
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-k>";
        action = "<Cmd>wincmd k<CR>";
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
        action = "<Cmd>wincmd j<CR>";
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
        action = "<Cmd>wincmd l<CR>";
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
        action = "<Cmd>wincmd h<CR>";
        options = {
          desc = "Cycle to left window";
        };
      }

      # Buffer
      {
        mode = "n";
        key = "<leader>bd";
        action = "<CMD>bdelete<CR>";
        options = {
          desc = "Delete buffer";
        };
      }

      # Move text up and down
      {
        mode = "n";
        key = "<A-k>";
        action = "<CMD>m .-2<CR>==";
        options = {
          desc = "Move text up";
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<CMD>m .+1<CR>==";
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
        action = "<CMD>m '<-2<CR>gv=gv";
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
        action = "<CMD>m '>+1<CR>gv=gv";
        options = {
          desc = "Move text down";
        };
      }
      {
        mode = "x";
        key = "K";
        action = "<CMD>m '<-2<CR>gv=gv";
        options = {
          desc = "Move text up";
        };
      }
      {
        mode = "x";
        key = "J";
        action = "<CMD>m '>+1<CR>gv=gv";
        options = {
          desc = "Move text down";
        };
      }
    ];
  };
}
