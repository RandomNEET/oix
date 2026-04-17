{
  config,
  lib,
  pkgs,
  meta,
  ...
}:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;
      nixGrammars = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        css
        diff
        gitcommit
        gitignore
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        python
        regex
        ron
        rust
        toml
        typescript
        vue
        yaml
      ];
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      folding.enable = !config.programs.nixvim.plugins.treesitter.lazyLoad.enable; # enable after lazyload
      highlight.enable = true;
      indent.enable = true;
    };
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "BufReadPost"
          "BufNewFile"
          "BufWritePre"
          "DeferredUIEnter"
        ];
        cmd = [
          "TSUpdate"
          "TSInstall"
          "TSLog"
          "TSUninstall"
        ];
        after.__raw = ''
          function()
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        '';
      };
    };
  };
}
