{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
in
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
    ''
    # Auto reload stylix colorscheme
    + lib.optionalString hasThemes ''
      local function reload_theme()
          vim.defer_fn(function()
              local f = io.open(vim.env.MYVIMRC, "r")
              if f then
                  local c = f:read("*all")
                  f:close()
                  local b16 = c:match('require%("mini.base16"%)%.setup%({.-}%)')
                  if b16 then
                      loadstring(b16)()
                  end
                  local h = { "Normal", "LineNr", "SignColumn", "NonText" }
                  for _, n in ipairs(h) do
                      vim.api.nvim_set_hl(0, n, { bg = "none" })
                  end
                  vim.notify("Theme reloaded")
              end
          end, 100)
      end

      local w = vim.loop.new_fs_event()
      local config_dir = vim.fn.expand("${config.xdg.configHome}/nvim")

      w:start(
          config_dir,
          {},
          vim.schedule_wrap(function(err, fname, events)
              if err then return end
              if fname == "init.lua" then
                  reload_theme()
              end
          end)
      )
    '';
  };
}
