{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          cmd = "ConformInfo";
          event = "BufWritePre";
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
        formatters = { };
        format_on_save = {
          lsp_format = "fallback";
          timeou_ms = 500;
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>lua require('conform').format({ aync = true, lsp_fallback = true })<cr>";
        options = {
          desc = "Format buffer";
        };
      }
    ];
  };
}
