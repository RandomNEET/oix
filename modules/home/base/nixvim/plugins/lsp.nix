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
