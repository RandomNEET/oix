{
  programs.nixvim = {
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        palette_overrides = {
          bright_blue = "#5476b2";
          bright_purple = "#fb4934";
          dark1 = "#323232";
          dark2 = "#383330";
          dark3 = "#323232";
        };
        terminal_colors = true;
      };
    };
  };
}
