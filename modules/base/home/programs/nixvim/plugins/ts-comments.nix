{
  programs.nixvim = {
    plugins.ts-comments = {
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
    };
  };
}
