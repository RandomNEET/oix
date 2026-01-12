{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        nixGrammars = true;
        folding.enable = false;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          diff
          python
          regex
          gitcommit
          gitignore
          html
          markdown
          markdown_inline
          nix
          json
          lua
          toml
          yaml
        ];
        settings = {
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context = {
        enable = false;
      };
    };
  };
}
