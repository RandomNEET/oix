{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          keys = [
            {
              __unkeyed-1 = "s";
              __unkeyed-2.__raw = "function() require('flash').jump() end";
              mode = [
                "n"
                "x"
                "o"
              ];
              desc = "Flash";
            }
            {
              __unkeyed-1 = "S";
              __unkeyed-2.__raw = "function() require('flash').treesitter() end";
              mode = [
                "n"
                "x"
                "o"
              ];
              desc = "Flash Treesitter";
            }
            {
              __unkeyed-1 = "r";
              __unkeyed-2.__raw = "function() require('flash').remote() end";
              mode = "o";
              desc = "Remote Flash";
            }
            {
              __unkeyed-1 = "R";
              __unkeyed-2.__raw = "function() require('flash').treesitter_search() end";
              mode = [
                "o"
                "x"
              ];
              desc = "Treesitter Search";
            }
            {
              __unkeyed-1 = "<A-s>";
              __unkeyed-2.__raw = "function() require('flash').toggle() end";
              mode = "c";
              desc = "Toggle Flash Search";
            }
          ];
        };
      };
    };
  };
}
