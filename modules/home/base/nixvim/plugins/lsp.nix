{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
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
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "BufReadPre"
          "BufNewFile"
        ];
      };
    };
  };
}
