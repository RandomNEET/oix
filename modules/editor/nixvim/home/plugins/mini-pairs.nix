{
  programs.nixvim = {
    plugins.mini-pairs = {
      enable = true;
      settings = {
        modes = {
          insert = true;
          command = true;
          terminal = false;
        };
      };
      luaConfig.post = ''
        -- configurable options
        local opts = {
        	skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        	skip_ts = { "string" },
        	skip_unbalanced = true,
        	markdown = true,
        }

        local pairs = require("mini.pairs")
        local open = pairs.open
        pairs.open = function(pair, neigh_pattern)
        	if vim.g.minipairs_disable then
        		return pair:sub(1, 1)
        	end
        	if vim.fn.getcmdline() ~= "" then
        		return open(pair, neigh_pattern)
        	end
        	local o, c = pair:sub(1, 1), pair:sub(2, 2)
        	local line = vim.api.nvim_get_current_line()
        	local cursor = vim.api.nvim_win_get_cursor(0)
        	local next_char = line:sub(cursor[2] + 1, cursor[2] + 1)
        	local before = line:sub(1, cursor[2])
        	-- markdown
        	if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
        		return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        	end
        	-- skip_next
        	if opts.skip_next and next_char ~= "" and next_char:match(opts.skip_next) then
        		return o
        	end
        	-- skip_ts
        	if opts.skip_ts and #opts.skip_ts > 0 then
        		local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        		for _, capture in ipairs(ok and captures or {}) do
        			if vim.tbl_contains(opts.skip_ts, capture.capture) then
        				return o
        			end
        		end
        	end
        	-- skip_unbalanced
        	if opts.skip_unbalanced and next_char == c and c ~= o then
        		local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
        		local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
        		if count_close > count_open then
        			return o
        		end
        	end
        	return open(pair, neigh_pattern)
        end
      '';
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
            "BufWritePre"
          ];
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>lua vim.g.minipairs_disable = not vim.g.minipairs_disable<cr>";
        options = {
          desc = "Toggle Mini Pairs";
        };
      }
    ];
  };
}
