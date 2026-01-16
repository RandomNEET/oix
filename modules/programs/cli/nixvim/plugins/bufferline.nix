{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors;
in
{
  programs.nixvim =
    let
      cwd = config.lib.nixvim.mkRaw ''
        function()
          local full_path = vim.fn.getcwd()
          local home = vim.fn.expand("~")
          local max_length = 30
          local display_path
          
          if full_path:sub(1, #home) == home then
            display_path = full_path:gsub(home, "~", 1)
          else
            display_path = full_path
          end
          
          if #display_path > max_length then
            local parts = vim.split(display_path, "[/\\]")
            
            local num_parts_to_keep = 3 
            local start_index = math.max(1, #parts - num_parts_to_keep + 1)
            
            local abbreviated_parts = {}
            for i = start_index, #parts do
              table.insert(abbreviated_parts, parts[i])
            end
            
            display_path = table.concat(abbreviated_parts, "/")
            
            if #parts > num_parts_to_keep then
                display_path = "…/" .. display_path
            end
          end
          
          return display_path
        end
      '';
    in
    {
      plugins.bufferline = {
        enable = true;
        settings = {
          options = {
            mode = "buffers";
            style_preset = "bufferline.style_preset.default";
            numbers = "ordinal";
            indicator = {
              icon = "▎";
              style = "icon";
            };
            buffer_close_icon = "󰅖";
            modified_icon = "●";
            close_icon = "";
            left_trunc_marker = " ";
            right_trunc_marker = " ";
            tab_size = 18;
            diagnostics = "nvim_lsp";
            offsets = [
              {
                filetype = "snacks_layout_box";
                text = cwd;
                text_align = "left";
                separator = true;
              }
            ];
            show_buffer_icons = true;
            show_buffer_close_icons = false;
            separator_style = "thin"; # “slant”, “padded_slant”, “slope”, “padded_slope”, “thick”, “thin”
          };
        };
      };
      keymaps = [
        {
          mode = "n";
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Cycle to next buffer";
          };
        }
        {
          mode = "n";
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Cycle to previous buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>bo";
          action = "<cmd>BufferLineCloseOthers<cr>";
          options = {
            desc = "Delete other buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>br";
          action = "<cmd>BufferLineCloseRight<cr>";
          options = {
            desc = "Delete buffers to the right";
          };
        }
        {
          mode = "n";
          key = "<leader>bl";
          action = "<cmd>BufferLineCloseLeft<cr>";
          options = {
            desc = "Delete buffers to the left";
          };
        }
        {
          mode = "n";
          key = "<leader>bp";
          action = "<cmd>BufferLineTogglePin<cr>";
          options = {
            desc = "Toggle pin";
          };
        }
        {
          mode = "n";
          key = "<leader>bP";
          action = "<cmd>BufferLineGroupClose ungrouped<cr>";
          options = {
            desc = "Delete non-pinned buffers";
          };
        }
      ];
      highlightOverride = lib.mkIf hasThemes {
        # --- Buffers ---
        BufferLineBackground = {
          bg = "#${colors.base01}";
        };
        BufferLineBufferVisible = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
        };
        BufferLineBufferSelected = {
          fg = "#${colors.base05}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };

        # --- Duplicate ---
        BufferLineDuplicateSelected = {
          fg = "#${colors.base05}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };
        BufferLineDuplicateVisible = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
          bold = true;
          italic = false;
        };
        BufferLineDuplicate = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
          bold = true;
          italic = false;
        };

        # --- Tabs ---
        BufferLineTab = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
        };
        BufferLineTabSelected = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base00}";
          bold = true;
        };
        BufferLineTabSeparator = {
          fg = "#${colors.base01}";
          bg = "#${colors.base01}";
        };
        BufferLineTabSeparatorSelected = {
          fg = "#${colors.base01}";
          bg = "#${colors.base00}";
        };
        BufferLineTabClose = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };

        # --- Indicators ---
        BufferLineIndicatorVisible = {
          fg = "#${colors.base01}"; # 隐藏或变暗
          bg = "#${colors.base01}";
        };
        BufferLineIndicatorSelected = {
          fg = "#${colors.base09}"; # 图片中的垂直橙色条
          bg = "#${colors.base00}"; # 确保背景与选中标签一致
        };

        # --- Separators ---
        BufferLineSeparator = {
          fg = "#${colors.base01}";
          bg = "#${colors.base01}";
        };
        BufferLineSeparatorVisible = {
          fg = "#${colors.base01}";
          bg = "#${colors.base01}";
        };
        BufferLineSeparatorSelected = {
          fg = "#${colors.base01}";
          bg = "#${colors.base00}";
        };
        BufferLineOffsetSeparator = {
          fg = "#${colors.base01}";
          bg = "#${colors.base00}";
        };

        # --- Close Buttons ---
        BufferLineCloseButton = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
        };
        BufferLineCloseButtonVisible = {
          fg = "#${colors.base03}";
          bg = "#${colors.base01}";
        };
        BufferLineCloseButtonSelected = {
          fg = "#${colors.base08}";
          bg = "#${colors.base00}";
        };

        # --- Fill ---
        BufferLineFill = {
          bg = "#${colors.base01}";
        };

        # --- Numbers ---
        BufferLineNumbers = {
          fg = "#${colors.base04}";
          bg = "#${colors.base01}";
        };
        BufferLineNumbersVisible = {
          fg = "#${colors.base04}";
          bg = "#${colors.base01}";
        };
        BufferLineNumbersSelected = {
          fg = "#${colors.base04}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };

        # --- Icons  ---
        BufferLineMiniIconsAzure = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsAzureSelected = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsAzureInactive = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsBlue = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsBlueSelected = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsBlueInactive = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsCyan = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsCyanSelected = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsCyanInactive = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsGreen = {
          fg = "#${colors.base0B}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsGreenSelected = {
          fg = "#${colors.base0B}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsGreenInactive = {
          fg = "#${colors.base0B}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsGrey = {
          fg = "#${colors.base04}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsGreySelected = {
          fg = "#${colors.base04}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsGreyInactive = {
          fg = "#${colors.base04}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsOrange = {
          fg = "#${colors.base09}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsOrangeSelected = {
          fg = "#${colors.base09}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsOrangeInactive = {
          fg = "#${colors.base09}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsPurple = {
          fg = "#${colors.base0E}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsPurpleSelected = {
          fg = "#${colors.base0E}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsPurpleInactive = {
          fg = "#${colors.base0E}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsRed = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsRedSelected = {
          fg = "#${colors.base08}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsRedInactive = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsWhite = {
          fg = "#${colors.base05}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsWhiteSelected = {
          fg = "#${colors.base05}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsWhiteInactive = {
          fg = "#${colors.base05}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsYellow = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };
        BufferLineMiniIconsYellowSelected = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base00}";
        };
        BufferLineMiniIconsYellowInactive = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };

        # --- Diagnostics ---
        BufferLineError = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineErrorVisible = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineErrorSelected = {
          fg = "#${colors.base08}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };
        BufferLineErrorDiagnostic = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineErrorDiagnosticVisible = {
          fg = "#${colors.base08}";
          bg = "#${colors.base01}";
        };
        BufferLineErrorDiagnosticSelected = {
          fg = "#${colors.base08}";
          bg = "#${colors.base00}";
        };

        BufferLineWarning = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };
        BufferLineWarningVisible = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };
        BufferLineWarningSelected = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };
        BufferLineWarningDiagnostic = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };
        BufferLineWarningDiagnosticVisible = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base01}";
        };
        BufferLineWarningDiagnosticSelected = {
          fg = "#${colors.base0A}";
          bg = "#${colors.base00}";
        };

        BufferLineInfo = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineInfoVisible = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base01}";
        };
        BufferLineInfoSelected = {
          fg = "#${colors.base0D}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };

        BufferLineHint = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base01}";
        };
        BufferLineHintVisible = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base01}";
        };
        BufferLineHintSelected = {
          fg = "#${colors.base0C}";
          bg = "#${colors.base00}";
          bold = true;
          italic = false;
        };

        # --- Modified ---
        BufferLineModified = {
          fg = "#${colors.base09}";
          bg = "#${colors.base01}";
        };
        BufferLineModifiedVisible = {
          fg = "#${colors.base09}";
          bg = "#${colors.base01}";
        };
        BufferLineModifiedSelected = {
          fg = "#${colors.base09}";
          bg = "#${colors.base00}";
        };
      };
    };
  #   highlightOverride = lib.mkIf hasThemes {
  #     BufferLineNumbersSelected = {
  #       bg = "none";
  #     };
  #     BufferLineMiniIconsAzureSelected = {
  #       bg = "none";
  #     };
  #     BufferLineMiniIconsGreySelected = {
  #       bg = "none";
  #     };
  #   };
  # };
}
