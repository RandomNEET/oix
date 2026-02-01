{
  programs.nixvim = {
    plugins.ts-context-commentstring = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
        };
      };
      disableAutoInitialization = false;
      settings = {
        enable_autocmd = false;
      };
    };
  };
}
