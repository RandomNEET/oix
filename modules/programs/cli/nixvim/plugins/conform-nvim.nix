{ lib, opts, ... }:
{
  programs.nixvim = {
    keymaps = lib.mkIf (opts.nixvim.conform.enable or true) [
      {
        mode = "n";
        key = "<leader>fm";
        action = "<CMD>lua require('conform').format({ aync = true, lsp_fallback = true })<CR>";
        options = {
          desc = "Format buffer";
        };
      }
    ];
    plugins.conform-nvim = {
      enable = opts.nixvim.conform.enable or true;
      settings = {
        formatters_by_ft = {
          c = [ "astyle" ];
          cpp = [ "astyle" ];
          css = [
            "prettierd"
            "prettier"
          ];
          html = [
            "prettierd"
            "prettier"
          ];
          javascript = [
            "prettierd"
            "prettier"
          ];
          javascriptreact = [ "prettier" ];
          json = [ "prettier" ];
          lua = [ "stylua" ];
          markdown = [ "prettier" ];
          nix = [ "nixfmt" ];
          python = [
            "isort"
            "black"
          ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
          typescript = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [ "prettier" ];
          vue = [ "prettier" ];
          yaml = [
            "prettierd"
            "prettier"
          ];
        };
        formatters = { };
        format_on_save = {
          lsp_format = "fallback";
          timeou_ms = 500;
        };
      };
    };
  };
}
