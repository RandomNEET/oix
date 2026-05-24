{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true; # nix
        bashls.enable = true; # bash
        lua_ls.enable = true; # lua
        pyright.enable = true; # python
        clangd.enable = true; # c/cpp
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        }; # rust
        html.enable = true; # html
        ts_ls.enable = true; # ts/js
        vue_ls.enable = true; # vue
        jsonls.enable = true; # json
        yamlls.enable = true; # yaml
        taplo.enable = true; # toml
        marksman.enable = true; # markdown
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
  };
}
