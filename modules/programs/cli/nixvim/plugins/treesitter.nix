{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter = rec {
      enable = true;
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
      folding.enable = !lazyLoad.enable; # enable after lazyload
      nixvimInjections = true;
      highlight.enable = true;
      indent.enable = true;
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
      settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
        indent.enable = true;
      };
    };
  };
}
