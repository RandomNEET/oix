{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
      settings = {
        modes = {
          insert = true;
          command = true;
          terminal = false;
        };
        skip_next.__raw = ''[=[[%w%%%'%[%"%.%`%$]]=]'';
        skip_ts = [ "string" ];
        skip_unbalanced = true;
        markdown = true;
      };
    };
  };
}
