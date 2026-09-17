{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter = rec {
      enable = true;
      nixvimInjections = true;
      nixGrammars = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        nix
        bash
        zsh
        lua
        c
        cpp
        rust
        python
        html
        javascript
        typescript
        css
        json
        ron
        toml
        yaml
        markdown
        markdown_inline
        regex
        make
        diff
        gitcommit
        gitignore
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
    extraConfigLuaPre = ''
      -- Compatibility for outdated Nix Tree-sitter queries.
      -- New nvim-treesitter no longer provides this predicate.
      vim.treesitter.query.add_predicate("is-not?", function()
        return true
      end)
    '';
  };
}
