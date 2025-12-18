{ lib, opts, ... }:
let
  lintEnabled = opts.nixvim.lint.enable or true;
in
{
  programs.nixvim = {
    plugins.lint = {
      enable = lintEnabled;
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
    extraConfigLua = lib.mkIf lintEnabled ''
      -- Linting function
      local lint = require("lint")
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      	group = lint_augroup,
      	callback = function()
      		lint.try_lint()
      	end,
      })

      local lint_progress = function()
      	local linters = require("lint").get_running()
      	if #linters == 0 then
      		return "󰦕"
      	end
      	return "󱉶 " .. table.concat(linters, ", ")
      end

      vim.keymap.set("n", "<leader>lt", function()
      	lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    '';
  };
}
