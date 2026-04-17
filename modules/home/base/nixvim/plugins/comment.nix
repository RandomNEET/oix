{
  config,
  lib,
  meta,
  ...
}:
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
      }
      // lib.optionalAttrs config.programs.nixvim.plugins.ts-context-commentstring.enable {
        pre_hook = ''
          require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        '';
      }
      // lib.optionalAttrs (meta.channel == "unstable") {
        lazyLoad = {
          enable = true;
          settings = {
            event = "DeferredUIEnter";
          };
        };
      };
    };
  };
}
