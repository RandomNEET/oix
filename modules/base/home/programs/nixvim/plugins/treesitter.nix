{ config, ... }:
{
  programs.nixvim = {
    plugins.treesitter = rec {
      enable = true;
      nixvimInjections = true;
      nixGrammars = true;
      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
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
  };
}
