{
  programs.nixvim = {
    plugins.mini-icons = {
      enable = true;
      mockDevIcons = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
