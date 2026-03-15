{
  programs.nixvim = {
    plugins.ts-context-commentstring = {
      enable = true;
      disableAutoInitialization = false;
      settings = {
        enable_autocmd = false;
      };
    };
  };
}
