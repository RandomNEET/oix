{
  osConfig,
  config,
  lib,
  ...
}:
let
  hasDesktop = osConfig.desktop.enable;
  hasThemes = osConfig.desktop.themes.enable;
in
{
  programs.nixvim = {
    opts = {
      # UI
      number = true;
      relativenumber = true;
      termguicolors = true;
      cursorline = true;
      scrolloff = 8;
      fillchars = "eob: ";

      # Layout
      splitbelow = true;
      splitright = true;

      # Indent
      expandtab = true;
      shiftwidth = 2;
      softtabstop = 2;
      tabstop = 2;

      # Completion
      wildignorecase = true;
      wildmenu = true;
      wildmode = "longest:full,full";

      # Search
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      smartcase = true;

      # Diff
      diffopt = [
        "internal"
        "filler"
        "closeoff"
        "indent-heuristic"
        "linematch:60"
      ];

      # Fold
      foldlevel = 99;

      # Undo
      undofile = true;
      undolevels = 10000;
      undoreload = 10000;
    };

    diagnostic = {
      settings = {
        virtual_text = false;
      };
    };

    clipboard = {
      register = "unnamedplus";
      providers = lib.mkIf hasDesktop {
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
      _G.reload_theme = function()
        vim.defer_fn(function()
          local f = io.open(vim.env.MYVIMRC, "r")
          if f then
            local c = f:read("*all")
            f:close()

            local b16 = c:match('require%("mini.base16"%)%.setup%({.-}%)')
            if b16 then
              local func, err = loadstring(b16)
              if func then
                func()
              end
            end

            local hl_block = c:match("%-%- Highlight groups {{%s*(.-)%s*%-%- }}")
            if hl_block then
              local func, err = loadstring(hl_block)
              if func then
                func()
              else
                vim.notify("Highlight block parse error: " .. tostring(err), vim.log.levels.ERROR)
              end
            end

            local fallback_h = { "Normal", "LineNr", "SignColumn", "NonText", "NormalFloat", "FloatBorder" }
            for _, n in ipairs(fallback_h) do
              vim.api.nvim_set_hl(0, n, { bg = "none" })
            end

            ${lib.optionalString config.programs.nixvim.plugins.lualine.enable ''
              local ok_lualine, lualine = pcall(require, "lualine")
              if ok_lualine then
                local current_config = lualine.get_config()
                lualine.setup(current_config)
              end
            ''}

            vim.notify("Theme reloaded")
          end
        end, 100)
      end
    '';
  };
}
