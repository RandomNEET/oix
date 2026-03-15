{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
    keymaps = [
      # Flash Navigation
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash";
      }
      {
        mode = [
          "n"
          "o"
          "x"
        ];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<cr>";
        options.desc = "Flash Treesitter";
      }
      {
        mode = "o";
        key = "r";
        action = "<cmd>lua require('flash').remote()<cr>";
        options.desc = "Remote Flash";
      }
      {
        mode = [
          "o"
          "x"
        ];
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        options.desc = "Treesitter Search";
      }
      {
        mode = "c";
        key = "<c-s>";
        action = "<cmd>lua require('flash').toggle()<cr>";
        options.desc = "Toggle Flash Search";
      }

      # Simulate nvim-treesitter incremental selection
      {
        mode = [
          "n"
          "o"
          "x"
        ];
        key = "<c-space>";
        action.__raw = ''
          function()
            require("flash").treesitter({
              actions = {
                ["<c-space>"] = "next",
                ["<BS>"] = "prev"
              }
            }) 
          end
        '';
        options.desc = "Treesitter Incremental Selection";
      }
    ];
  };
}
