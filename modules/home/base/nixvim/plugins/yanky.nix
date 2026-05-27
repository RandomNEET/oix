{
  programs.nixvim = {
    plugins.yanky = {
      enable = true;
      settings = {
        system_clipboard = {
          sync_with_ring = {
            __raw = "not vim.env.SSH_CONNECTION";
          };
        };
        highlight = {
          timer = 150;
        };
      };
      lazyLoad = {
        enable = true;
        settings = {
          event = [
            "BufReadPost"
            "BufNewFile"
            "BufWritePre"
          ];
          keys = [
            {
              __unkeyed-1 = "<leader>p";
              __unkeyed-2.__raw = ''
                function()
                  if _G.Snacks ~= nil and _G.Snacks.picker ~= nil then
                    Snacks.picker.yanky()
                  elseif pcall(require, "telescope") then
                    require("telescope").extensions.yank_history.yank_history({})
                  else
                    vim.cmd([[YankyRingHistory]])
                  end
                end
              '';
              mode = [
                "n"
                "x"
              ];
              desc = "Open Yank History";
            }
            {
              __unkeyed-1 = "y";
              __unkeyed-2 = "<Plug>(YankyYank)";
              mode = [
                "n"
                "x"
              ];
              desc = "Yank Text";
            }
            {
              __unkeyed-1 = "p";
              __unkeyed-2 = "<Plug>(YankyPutAfter)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put Text After Cursor";
            }
            {
              __unkeyed-1 = "P";
              __unkeyed-2 = "<Plug>(YankyPutBefore)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put Text Before Cursor";
            }
            {
              __unkeyed-1 = "gp";
              __unkeyed-2 = "<Plug>(YankyGPutAfter)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put Text After Selection";
            }
            {
              __unkeyed-1 = "gP";
              __unkeyed-2 = "<Plug>(YankyGPutBefore)";
              mode = [
                "n"
                "x"
              ];
              desc = "Put Text Before Selection";
            }
            {
              __unkeyed-1 = "[y";
              __unkeyed-2 = "<Plug>(YankyCycleForward)";
              desc = "Cycle Forward Through Yank History";
            }
            {
              __unkeyed-1 = "]y";
              __unkeyed-2 = "<Plug>(YankyCycleBackward)";
              desc = "Cycle Backward Through Yank History";
            }
            {
              __unkeyed-1 = "]p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
              desc = "Put Indented After Cursor (Linewise)";
            }
            {
              __unkeyed-1 = "[p";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
              desc = "Put Indented Before Cursor (Linewise)";
            }
            {
              __unkeyed-1 = "]P";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterLinewise)";
              desc = "Put Indented After Cursor (Linewise)";
            }
            {
              __unkeyed-1 = "[P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeLinewise)";
              desc = "Put Indented Before Cursor (Linewise)";
            }
            {
              __unkeyed-1 = ">p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftRight)";
              desc = "Put and Indent Right";
            }
            {
              __unkeyed-1 = "<p";
              __unkeyed-2 = "<Plug>(YankyPutIndentAfterShiftLeft)";
              desc = "Put and Indent Left";
            }
            {
              __unkeyed-1 = ">P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftRight)";
              desc = "Put Before and Indent Right";
            }
            {
              __unkeyed-1 = "<P";
              __unkeyed-2 = "<Plug>(YankyPutIndentBeforeShiftLeft)";
              desc = "Put Before and Indent Left";
            }
            {
              __unkeyed-1 = "=p";
              __unkeyed-2 = "<Plug>(YankyPutAfterFilter)";
              desc = "Put After Applying a Filter";
            }
            {
              __unkeyed-1 = "=P";
              __unkeyed-2 = "<Plug>(YankyPutBeforeFilter)";
              desc = "Put Before Applying a Filter";
            }
          ];
        };
      };
    };
  };
}
