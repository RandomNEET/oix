{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter = rec {
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
        yaml
      ];
      highlight.enable = true;
      indent.enable = true;
      folding.enable = !lazyLoad.enable; # enable after lazyload
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
  };
}
