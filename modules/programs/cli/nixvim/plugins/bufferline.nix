{
  programs.nixvim =
    { lib, ... }:
    let
      cwd = lib.nixvim.mkRaw ''
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
    };
}
