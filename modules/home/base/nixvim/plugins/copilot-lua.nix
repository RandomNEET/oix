{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = "InsertEnter";
        };
      };
      settings = {
        panel = {
          enabled = true;
          auto_refresh = false;
          keymap = {
            open = "<C-CR>";
          };
          layout = {
            position = "right";
            ratio = 0.4;
          };
        };
        suggestion = {
          enabled = true;
          auto_trigger = false;
        };
        server_opts_overrides = {
          offset_encoding = "utf-8";
        };
        filetypes = {
          "." = false;
          cvs = false;
          gitcommit = false;
          gitrebase = false;
          help = false;
          hgcommit = false;
          markdown = false;
          svn = false;
          yaml = true;
        };
      };
    };
  };
}
