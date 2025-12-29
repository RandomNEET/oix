{
  lib,
  pkgs,
  opts,
  ...
}:
{
  programs.nixvim = lib.mkIf (opts.nixvim.treesitter.enable or true) {
    plugins = {
      treesitter-context = {
        enable = false;
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
        nixGrammars = true;
        folding = false;
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
    };
  };
}
