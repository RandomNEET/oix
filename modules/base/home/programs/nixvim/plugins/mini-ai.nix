{
  programs.nixvim = {
    plugins.mini-ai = {
      enable = true;
      settings = {
        n_lines = 500;
        search_method = "cover_or_nearest";
        silent = true;
      };
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
    };
  };
}
