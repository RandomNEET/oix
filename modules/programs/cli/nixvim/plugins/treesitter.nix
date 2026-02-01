{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
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
