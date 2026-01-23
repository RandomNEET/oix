{
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufWritePost"
          ];
          keys = [
            {
              __unkeyed-1 = "<leader>lt";
              __unkeyed-2.__raw = "function() require('lint').try_lint() end";
              desc = "Trigger linting";
            }
          ];
        };
      };
      lintersByFt = {
        c = [ "clangtidy" ];
        cpp = [ "clangtidy" ];
        css = [ "eslint_d" ];
        gitcommit = [ "commitlint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        json = [ "jq" ];
        lua = [ "luacheck" ];
        markdownlint = [ "markdownlint" ];
        nix = [ "nix" ];
        python = [ "ruff" ];
        sh = [ "shellcheck" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        yaml = [ "yamllint" ];
        vue = [ "eslint_d" ];
      };
      linters = { };
    };
    extraConfigLua = ''
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          local status, lint = pcall(require, "lint")
          if status and lint then
            lint.try_lint()
          end
        end,
      })

      _G.lint_progress = function()
        local status, lint = pcall(require, "lint")
        if not status or not lint then return "" end
        
        local ok, linters = pcall(lint.get_running)
        if not ok then return "󰦕" end
        
        return #linters == 0 and "󰦕" or ("󱉶 " .. table.concat(linters, ", "))
      end
    '';
  };
}
