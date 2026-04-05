{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPre"
            "BufNewFile"
          ];
        };
      };
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
          "<leader>cd" = "open_float";
        };
        lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };
      servers = {
        bashls.enable = true;
        clangd.enable = true;
        html.enable = true;
        lua_ls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        taplo.enable = true;
        ts_ls.enable = true;
        jsonls.enable = true;
        vue_ls.enable = true;
        yamlls.enable = true;
      };
    };
  };
}
