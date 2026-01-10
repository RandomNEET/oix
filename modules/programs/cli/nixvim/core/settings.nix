{ lib, opts, ... }:
{
  programs.nixvim = {
    opts = {
      termguicolors = true;

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

      diffopt = [
        "internal"
        "filler"
        "closeoff"
        "indent-heuristic"
        "linematch:60"
      ];
    };

    diagnostic = {
      settings = {
        virtual_text = false;
      };
    };

    clipboard = {
      register = "unnamedplus";
      providers = lib.mkIf ((opts.desktop or "") != "") {
        wl-copy.enable = true;
        xclip.enable = true;
      };
    };
    # Use OSC 52 for clipboard sync when connected via ssh
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
}
