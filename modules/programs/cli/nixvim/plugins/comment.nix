{
  programs.nixvim = {
    plugins.comment = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          keys = [
            "gc"
            "gb"
          ];
        };
      };
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
      };
    };
  };
}
