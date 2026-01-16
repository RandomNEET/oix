{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        lua_ls.enable = true;
        yamlls.enable = true;
        nil_ls.enable = true;
        marksman.enable = true;
        pyright.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        bashls.enable = true;
        jsonls.enable = true;
        ts_ls.enable = true;
        html.enable = true;
        vue_ls.enable = true;
      };
      keymaps = {
        silent = true;
        diagnostic = {
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };
        lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };
    };
  };
}
