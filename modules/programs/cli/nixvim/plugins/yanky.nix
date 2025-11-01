{
  programs.nixvim = {
    plugins.yanky = {
      enable = true;
      settings = {
        highlight = {
          on_put = true;
          on_yank = true;
          timer = 100;
        };
      };
    };
  };
}
