{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
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
          toml = [ "taplo" ];
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
    };
  };
}
