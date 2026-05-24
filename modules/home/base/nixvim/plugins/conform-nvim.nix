{
  lib,
  pkgs,
  meta,
  ...
}:
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          lua = [ "stylua" ];
          python = [
            "isort"
            "black"
          ];
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          rust = [ "rustfmt" ];
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
          typescript = [
            "prettierd"
            "prettier"
          ];
          typescriptreact = [ "prettier" ];
          vue = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [
            "prettierd"
            "prettier"
          ];
          toml = [ "taplo" ];
          markdown = [ "prettier" ];
        };
        formatters = {
          injected = {
            options = {
              ignore_errors = true;
            };
          };
        };
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          cmd = "ConformInfo";
          event = "BufWritePre";
          keys = [
            {
              __unkeyed-1 = "<leader>cf";
              __unkeyed-2 = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
              mode = [
                "n"
                "v"
              ];
              desc = "Format buffer";
            }
            {
              __unkeyed-1 = "<leader>cF";
              __unkeyed-2 = "<cmd>lua require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })<cr>";
              mode = [
                "n"
                "v"
              ];
              desc = "Format Injected Langs";
            }
          ];
        };
      };
    };
    extraPackages = with pkgs; [
      nixfmt
      shfmt
      stylua
      isort
      black
      rustfmt
      prettier
      prettierd
    ];
  };
}
