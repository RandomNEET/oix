{
  config,
  lib,
  opts,
  ...
}:
let
  hasThemes = opts ? themes;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        bigfile = {
          enabled = true;
        };
        dashboard = {
          enabled =
            if config.programs.nixvim.plugins.kitty-scrollback.enable then
              { __raw = "vim.env.KITTY_SCROLLBACK_NVIM == nil"; }
            else
              true;
          pane_gap = 1;
          preset = {
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = ":lua Snacks.dashboard.pick('files')";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "g";
                desc = "Find Text";
                action = ":lua Snacks.dashboard.pick('live_grep')";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = ":lua Snacks.dashboard.pick('oldfiles')";
              }
              {
                icon = " ";
                key = "s";
                desc = "Select Session";
                action = ":lua require('persistence').select()";
              }
              {
                icon = " ";
                key = "l";
                desc = "Load Session";
                action = ":lua require('persistence').load()";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
            header = ''
              ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
              ⡟⣩⣛⣛⠛⠋⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠻⢿⡿⠿⠿⠿⠿⠟⠛⠛⠛⠛⠛⠛⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
              ⣧⠫⣉⠁⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⢿⣿
              ⣿⢠⣮⡄⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢔⢿⢸⣿
              ⣿⠂⢿⢘⠀⠈⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠩⢈⣼⣿
              ⣿⡆⡶⣮⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠁⠐⢸⣿⣿
              ⣿⣿⣶⠘⠬⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⡂⣬⠇⣾⣿⣿
              ⣿⣿⣿⡦⠘⠃⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡄⣼⣿⣿⣿
              ⣿⣿⣿⣇⢻⠿⣱⠀⠀⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⣰⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣴⣿⣿⣿⣿
              ⣿⣿⣿⣿⣤⠀⢃⡄⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠁⣼⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿
              ⣿⣿⣿⣿⣿⣷⡈⠱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠛⣿⠇⠂⠀⠀⠀⠀⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿
              ⣿⣿⣿⣿⣿⣿⡷⠂⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⣄⡅⠀⠀⠀⢠⣦⣠⡣⠊⠀⠀⠀⠀⠀⢀⠼⡟⠀⠄⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿
              ⠙⠻⢿⣿⡿⠋⠀⠀⠀⠀⠀⠀⢀⠧⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣶⣾⣿⣿⣷⣶⣶⣯⣄⠀⠀⠀⠈⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀⡄⢿⣿⣿
              ⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠈⢘⠀⠀⠀⠀⠀⡀⠀⣙⣻⣿⣿⣿⣿⣿⣿⣿⣶⢻⣿⣄⡃⠀⡸⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⢸⣿⣿
              ⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⢸⢸⡘⣿⣿
              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠿⣿⣿⣿⣯⣙⢿⣿⣿⡿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣠⢁⣿⣿
              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠄⢠⡀⢈⢓⡲⠶⣤⣬⣍⣙⠛⠿⣶⣿⣿⣿⣿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠺⣿⣿
              ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⣀⠱⠀⠀⠀⠀⠀⢹⣿⣿⣶⣮⣭⣛⡻⢷⣶⡈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿
              ⡄⠀⠀⠀⠀⠀⠀⠀⢀⢀⣬⣅⣒⡿⢦⡀⠀⠀⠀⠀⠀⢉⠙⢛⠿⠿⣿⣿⣿⣶⣭⣝⡳⠦⣀⠀⠀⠒⠐⠂⠁⠐⠀⠀⠀⠀⠀⠀⠠⠀⡘
              ⡀⠀⠀⠀⠀⠠⠀⠀⠀⠀⠉⠛⠻⠿⣿⡇⠀⠀⠀⠀⢰⣦⣄⡀⢹⣶⣦⣬⣍⣛⠻⠿⢿⣿⣶⣇⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢠
              ⡇⣧⠀⠀⠀⠀⠂⣀⣀⣀⣀⡀⠀⠀⠈⢉⠈⠀⠀⠀⠀⢿⣿⣿⣷⣮⣝⣛⣻⣯⣭⣷⣶⣦⣬⠭⠁⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⡄⢶⠀
              ⣿⣿⣷⡀⠈⠀⢶⣿⣿⣿⣿⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠈⠀⠀⠀⠀⠘⠀⠜⠁⢀⣤⢠⡴⣿
              ⣿⣿⣿⡿⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⠿⣿⣿⣿⣿⣿⠿⢟⠫⠕⠐⠀⢀⠀⠀⠀⠀⠐⠻⢿⣷⣾⣿⣇⢷⡹
            '';
          };
          sections = [
            {
              pane = 1;
              section = "header";
            }
            {
              icon = " ";
              title = "Keymaps";
              pane = 2;
              section = "keys";
              indent = 2;
              padding = 1;
            }
            {
              icon = " ";
              title = "Recent Files";
              pane = 2;
              section = "recent_files";
              indent = 2;
              padding = 1;
            }
            {
              icon = " ";
              title = "Projects";
              pane = 2;
              section = "projects";
              indent = 2;
              padding = 1;
            }
          ];
        };
        explorer = {
          enabled = true;
          replace_netrw = true;
          trash = true;
        };
        indent = {
          enabled = true;
          indent = {
            enabled = true;
            char = "▏";
          };
          scope = {
            enabled = true;
            underline = false;
            char = "▎";
          };
        };
        input = {
          enabled = true;
        };
        picker = {
          enabled = true;
        };
        notifier = {
          enabled = true;
          border = "rounded";
        };
        quickfile = {
          enabled = true;
        };
        scope = {
          enabled = true;
        };
        scroll = {
          enabled = true;
        };
        statuscolumn = {
          enabled = true;
        };
        terminal = {
          enabled = true;
          win = {
            position = "bottom";
            height = 0.4;
            wo = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
            };
          };
        };
        words = {
          enabled = true;
        };
        image = {
          enabled = builtins.elem (opts.terminal or "") [
            "kitty"
            "ghostty"
            "wezterm"
          ];
        };
      };
    };
    keymaps = [
      # Buffers
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua require('snacks').bufdelete()<cr>";
        options = {
          desc = "Delete Buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>lua require('snacks').bufdelete.other()<cr>";
        options = {
          desc = "Delete Other Buffers";
        };
      }
      # Picker
      {
        mode = "n";
        action = "<cmd>lua require('snacks').picker.smart()<cr>";
        key = "<leader><space>";
        options = {
          desc = "Smart find files";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('snacks').picker.buffers()<cr>";
        key = "<leader>,";
        options = {
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('snacks').picker.grep()<cr>";
        key = "<leader>/";
        options = {
          desc = "Grep";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('snacks').picker.command_history()<cr>";
        key = "<leader>:";
        options = {
          desc = "Command history";
        };
      }
      {
        mode = "n";
        action = "<cmd>lua require('snacks').picker.notifications()<cr>";
        key = "<leader>n";
        options = {
          desc = "Notification history";
        };
      }
      {
        mode = "n";
        key = "<leader>dh";
        action = ''<cmd>lua Snacks.picker.files({ confirm = function(picker, item) picker:close() if item then vim.cmd("diffsplit " .. item.text) end end, title = "Select File to Diff" })<cr>'';
        options = {
          desc = "Horizontal diff split";
        };
      }
      {
        mode = "n";
        key = "<leader>dv";
        action = ''<cmd>lua Snacks.picker.files({ confirm = function(picker, item) picker:close() if item then vim.cmd("vertical diffsplit " .. item.text) end end, title = "Select File to Diff" })<cr>'';
        options = {
          desc = "Vertical diff split";
        };
      }
      # Explorer
      {
        mode = "n";
        action = "<cmd>lua require('snacks').explorer()<cr>";
        key = "<leader>e";
        options = {
          desc = "File explorer";
        };
      }
      # Terminal
      {
        mode = "n";
        action = "<cmd>lua require('snacks').terminal.toggle()<cr>";
        key = "<leader>t";
        options = {
          desc = "Toggle terminal";
        };
      }
    ];
    highlightOverride = lib.mkIf hasThemes {
      SnacksPicker = {
        fg = colors.base05;
        bg = "none";
      };
      SnacksPickerBorder = {
        fg = colors.base05;
        bg = "none";
      };
      SnacksIndent = {
        fg = colors.base02;
      };
      SnacksIndentScope = {
        fg = colors.base0C;
      };
    };
  };
}
