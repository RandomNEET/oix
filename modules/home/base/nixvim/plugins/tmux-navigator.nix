{
  programs.nixvim = {
    plugins.tmux-navigator = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
