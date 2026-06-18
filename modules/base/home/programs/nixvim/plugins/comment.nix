{
  programs.nixvim = {
    plugins.comment = {
      enable = true;
      settings = {
        padding = true;
        sticky = true;
        ignore = null;
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
        extra = {
          above = "gcO";
          below = "gco";
          eol = "gcA";
        };
        mappings = {
          basic = true;
          extra = true;
        };
        pre_hook = ''
          require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        '';
      };
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
  };
}
