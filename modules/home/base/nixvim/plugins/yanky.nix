{
  programs.nixvim = {
    plugins.yanky = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
            "BufWritePre"
          ];
        };
      };
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
