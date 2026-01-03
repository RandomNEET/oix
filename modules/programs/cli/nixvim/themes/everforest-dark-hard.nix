{
  programs.nixvim = {
    colorschemes.everforest = {
      enable = true;
      settings = {
        background = "hard";
        colors_override = {
          bg0 = [
            "#202020"
            "234"
          ];
          bg2 = [
            "#282828"
            "235"
          ];
        };
        dim_inactive_windows = 1;
      };
    };
  };
}
