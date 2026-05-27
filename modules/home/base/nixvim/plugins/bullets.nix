{
  programs.nixvim = {
    plugins.bullets = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          ft = [
            "markdown"
            "text"
            "gitcommit"
            "scratch"
          ];
        };
      };
    };
  };
}
