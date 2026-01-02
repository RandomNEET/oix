{
  programs.nixvim = {
    config = {
      opts = {
        ignorecase = true;
        smartcase = true;
        hlsearch = true;
        incsearch = true;

        wildmenu = true;
        wildmode = "longest:full,full";
        wildignorecase = true;

        number = true;
        relativenumber = true;

        splitright = true;
        splitbelow = true;
      };
      diagnostic.settings = {
        virtual_text = false;
      };
      extraConfigLua = ''
        local function is_ssh()
        	return vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY
        end

        if is_ssh() then
        	local function paste()
        		return {
        			vim.fn.split(vim.fn.getreg(""), "\n"),
        			vim.fn.getregtype(""),
        		}
        	end
        	vim.g.clipboard = {
        		name = "OSC 52",
        		copy = {
        			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        		},
        		paste = {
        			["+"] = paste,
        			["*"] = paste,
        		},
        	}
        end
      '';
    };
  };
}
