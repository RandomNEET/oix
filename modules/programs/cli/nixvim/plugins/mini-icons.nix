{
  programs.nixvim = {
    plugins.mini-icons = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
      mockDevIcons = true;
    };
  };
}
