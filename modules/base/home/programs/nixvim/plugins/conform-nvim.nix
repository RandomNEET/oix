{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      autoInstall = {
        enable = true;
      };
      luaConfig = {
        pre = ''
          local slow_format_filetypes = {}
        '';
      };
      settings = {
        log_level = "warn";
        notify_on_error = false;
        notify_no_formatters = false;
        default_format_opts = {
          timeout_ms = 3000;
          async = false;
          quiet = false;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          lua = [ "stylua" ];
          luau = [ "stylua" ];
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
        format_on_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
           end
        '';
        format_after_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      };
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
  };
}
