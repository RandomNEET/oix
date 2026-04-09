{ config, lib, ... }:
let
  hasThemes = config.desktop.themes.enable;
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.nixvim = {
    plugins.snacks.settings.picker = {
      enabled = true;
    };
    keymaps = [
      # Core
      {
        mode = "n";
        key = "<leader><space>";
        action = "<cmd>lua require('snacks').picker.smart()<cr>";
        options = {
          desc = "Smart Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>,";
        action = "<cmd>lua require('snacks').picker.buffers()<cr>";
        options = {
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>lua require('snacks').picker.grep()<cr>";
        options = {
          desc = "Grep";
        };
      }
      {
        mode = "n";
        key = "<leader>:";
        action = "<cmd>lua require('snacks').picker.command_history()<cr>";
        options = {
          desc = "Command History";
        };
      }
      {
        mode = "n";
        key = "<leader>n";
        action = "<cmd>lua require('snacks').picker.notifications()<cr>";
        options = {
          desc = "Notification History";
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua require('snacks').explorer()<cr>";
        options = {
          desc = "File Explorer";
        };
      }

      # Find
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>lua require('snacks').picker.buffers()<cr>";
        options = {
          desc = "Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>lua require('snacks').picker.files({ cwd = vim.fn.stdpath('config') })<cr>";
        options = {
          desc = "Find Config File";
        };
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua require('snacks').picker.files()<cr>";
        options = {
          desc = "Find Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua require('snacks').picker.git_files()<cr>";
        options = {
          desc = "Find Git Files";
        };
      }
      {
        mode = "n";
        key = "<leader>fp";
        action = "<cmd>lua require('snacks').picker.projects()<cr>";
        options = {
          desc = "Projects";
        };
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>lua require('snacks').picker.recent()<cr>";
        options = {
          desc = "Recent";
        };
      }

      # Git Integration
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>lua require('snacks').picker.git_branches()<cr>";
        options = {
          desc = "Git Branches";
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = "<cmd>lua require('snacks').picker.git_log()<cr>";
        options = {
          desc = "Git Log";
        };
      }
      {
        mode = "n";
        key = "<leader>gL";
        action = "<cmd>lua require('snacks').picker.git_log_line()<cr>";
        options = {
          desc = "Git Log Line";
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>lua require('snacks').picker.git_status()<cr>";
        options = {
          desc = "Git Status";
        };
      }
      {
        mode = "n";
        key = "<leader>gS";
        action = "<cmd>lua require('snacks').picker.git_stash()<cr>";
        options = {
          desc = "Git Stash";
        };
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>lua require('snacks').picker.git_diff()<cr>";
        options = {
          desc = "Git Diff (Hunks)";
        };
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = "<cmd>lua require('snacks').picker.git_log_file()<cr>";
        options = {
          desc = "Git Log File";
        };
      }

      # GitHub (gh)
      {
        mode = "n";
        key = "<leader>gi";
        action = "<cmd>lua require('snacks').picker.gh_issue()<cr>";
        options = {
          desc = "GitHub Issues (open)";
        };
      }
      {
        mode = "n";
        key = "<leader>gI";
        action = "<cmd>lua require('snacks').picker.gh_issue({ state = 'all' })<cr>";
        options = {
          desc = "GitHub Issues (all)";
        };
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>lua require('snacks').picker.gh_pr()<cr>";
        options = {
          desc = "GitHub Pull Requests (open)";
        };
      }
      {
        mode = "n";
        key = "<leader>gP";
        action = "<cmd>lua require('snacks').picker.gh_pr({ state = 'all' })<cr>";
        options = {
          desc = "GitHub Pull Requests (all)";
        };
      }

      # General Search
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>lua require('snacks').picker.lines()<cr>";
        options = {
          desc = "Buffer Lines";
        };
      }
      {
        mode = "n";
        key = "<leader>sB";
        action = "<cmd>lua require('snacks').picker.grep_buffers()<cr>";
        options = {
          desc = "Grep Open Buffers";
        };
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>lua require('snacks').picker.grep()<cr>";
        options = {
          desc = "Grep";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>sw";
        action = "<cmd>lua require('snacks').picker.grep_word()<cr>";
        options = {
          desc = "Visual Selection or Current Word";
        };
      }
      {
        mode = "n";
        key = "<leader>s\"";
        action = "<cmd>lua require('snacks').picker.registers()<cr>";
        options = {
          desc = "Registers";
        };
      }
      {
        mode = "n";
        key = "<leader>s/";
        action = "<cmd>lua require('snacks').picker.search_history()<cr>";
        options = {
          desc = "Search History";
        };
      }
      {
        mode = "n";
        key = "<leader>sa";
        action = "<cmd>lua require('snacks').picker.autocmds()<cr>";
        options = {
          desc = "Autocmds";
        };
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>lua require('snacks').picker.command_history()<cr>";
        options = {
          desc = "Command History";
        };
      }
      {
        mode = "n";
        key = "<leader>sC";
        action = "<cmd>lua require('snacks').picker.commands()<cr>";
        options = {
          desc = "Commands";
        };
      }
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>lua require('snacks').picker.diagnostics()<cr>";
        options = {
          desc = "Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sD";
        action = "<cmd>lua require('snacks').picker.diagnostics_buffer()<cr>";
        options = {
          desc = "Buffer Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>lua require('snacks').picker.help()<cr>";
        options = {
          desc = "Help Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sH";
        action = "<cmd>lua require('snacks').picker.highlights()<cr>";
        options = {
          desc = "Highlights";
        };
      }
      {
        mode = "n";
        key = "<leader>si";
        action = "<cmd>lua require('snacks').picker.icons()<cr>";
        options = {
          desc = "Icons";
        };
      }
      {
        mode = "n";
        key = "<leader>sj";
        action = "<cmd>lua require('snacks').picker.jumps()<cr>";
        options = {
          desc = "Jumps";
        };
      }
      {
        mode = "n";
        key = "<leader>sk";
        action = "<cmd>lua require('snacks').picker.keymaps()<cr>";
        options = {
          desc = "Keymaps";
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>lua require('snacks').picker.loclist()<cr>";
        options = {
          desc = "Location List";
        };
      }
      {
        mode = "n";
        key = "<leader>sm";
        action = "<cmd>lua require('snacks').picker.marks()<cr>";
        options = {
          desc = "Marks";
        };
      }
      {
        mode = "n";
        key = "<leader>sM";
        action = "<cmd>lua require('snacks').picker.man()<cr>";
        options = {
          desc = "Man Pages";
        };
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>lua require('snacks').picker.lazy()<cr>";
        options = {
          desc = "Search Plugin Specs (Lazy)";
        };
      }
      {
        mode = "n";
        key = "<leader>sq";
        action = "<cmd>lua require('snacks').picker.qflist()<cr>";
        options = {
          desc = "Quickfix List";
        };
      }
      {
        mode = "n";
        key = "<leader>sR";
        action = "<cmd>lua require('snacks').picker.resume()<cr>";
        options = {
          desc = "Resume Last Search";
        };
      }
      {
        mode = "n";
        key = "<leader>su";
        action = "<cmd>lua require('snacks').picker.undo()<cr>";
        options = {
          desc = "Undo History";
        };
      }
      {
        mode = "n";
        key = "<leader>uC";
        action = "<cmd>lua require('snacks').picker.colorschemes()<cr>";
        options = {
          desc = "Colorschemes";
        };
      }

      #  Diagnostics
      {
        mode = "n";
        key = "<leader>dd";
        action = "<cmd>lua require('snacks').picker.diagnostics()<cr>";
        options = {
          desc = "Project Diagnostics (Snacks)";
        };
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require('snacks').picker.diagnostics_buffer()<cr>";
        options = {
          desc = "Buffer Diagnostics (Snacks)";
        };
      }

      # LSP & Navigation
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua require('snacks').picker.lsp_definitions()<cr>";
        options = {
          desc = "Goto Definition";
        };
      }
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua require('snacks').picker.lsp_declarations()<cr>";
        options = {
          desc = "Goto Declaration";
        };
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua require('snacks').picker.lsp_references()<cr>";
        options = {
          desc = "LSP References";
          nowait = true;
        };
      }
      {
        mode = "n";
        key = "gI";
        action = "<cmd>lua require('snacks').picker.lsp_implementations()<cr>";
        options = {
          desc = "Goto Implementation";
        };
      }
      {
        mode = "n";
        key = "gy";
        action = "<cmd>lua require('snacks').picker.lsp_type_definitions()<cr>";
        options = {
          desc = "Goto Type Definition";
        };
      }
      {
        mode = "n";
        key = "gai";
        action = "<cmd>lua require('snacks').picker.lsp_incoming_calls()<cr>";
        options = {
          desc = "LSP Incoming Calls";
        };
      }
      {
        mode = "n";
        key = "gao";
        action = "<cmd>lua require('snacks').picker.lsp_outgoing_calls()<cr>";
        options = {
          desc = "LSP Outgoing Calls";
        };
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>lua require('snacks').picker.lsp_symbols()<cr>";
        options = {
          desc = "LSP Document Symbols";
        };
      }
      {
        mode = "n";
        key = "<leader>sS";
        action = "<cmd>lua require('snacks').picker.lsp_workspace_symbols()<cr>";
        options = {
          desc = "LSP Workspace Symbols";
        };
      }

      # Diff
      {
        mode = "n";
        key = "<leader>dfh";
        action.__raw = ''
          function()
            Snacks.picker.files({
              title = "Select File to Diff (Horizontal)",
              confirm = function(picker, item)
                picker:close()
                if item and (item.path or item.file) then
                  local target = item.path or item.file
                  vim.cmd("diffsplit " .. vim.fn.fnameescape(target))
                end
              end,
            })
          end
        '';
        options = {
          desc = "Horizontal diff split";
        };
      }
      {
        mode = "n";
        key = "<leader>dfv";
        action.__raw = ''
          function()
            Snacks.picker.files({
              title = "Select File to Diff (Vertical)",
              confirm = function(picker, item)
                picker:close()
                if item and (item.path or item.file) then
                  local target = item.path or item.file
                  vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(target))
                end
              end,
            })
          end
        '';
        options = {
          desc = "Vertical diff split";
        };
      }

      # Prevent Accidental Triggers
      {
        mode = [
          "n"
          "v"
        ];
        key = "q:";
        action = "<nop>";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "q/";
        action = "<nop>";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "q?";
        action = "<nop>";
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
    };
  };
}
