{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
    };
    keymaps = [
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        action = "<cmd>lua require('flash').jump()<cr>";
        key = "s";
        options = {
          desc = "Flash";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        action = "<cmd>lua require('flash').treesitter()<cr>";
        key = "S";
        options = {
          desc = "Flash Treesitter";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = [ "o" ];
        action = "<cmd>lua require('flash').remote()<cr>";
        key = "r";
        options = {
          desc = "Remote Flash";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = [
          "o"
          "x"
        ];
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        key = "R";
        options = {
          desc = "Treesitter Search";
          silent = true;
          noremap = true;
        };
      }
      {
        mode = [ "c" ];
        action = "<cmd>lua require('flash').toggle()<cr>";
        key = "<A-s>";
        options = {
          desc = "Toggle Flash Search";
          silent = true;
          noremap = true;
        };
      }
    ];
  };
}
