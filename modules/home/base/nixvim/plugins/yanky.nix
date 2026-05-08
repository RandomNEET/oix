{ lib, meta, ... }:
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
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
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
      }
      // lib.optionalAttrs (meta.channel == "stable") {
        keymaps = [
          {
            mode = [
              "n"
              "x"
            ];
            key = "<leader>p";
            action = {
              __raw = ''
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
            };
            options = {
              desc = "Open Yank History";
            };
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "y";
            action = "<Plug>(YankyYank)";
            options = {
              desc = "Yank Text";
            };
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "p";
            action = "<Plug>(YankyPutAfter)";
            options = {
              desc = "Put Text After Cursor";
            };
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "P";
            action = "<Plug>(YankyPutBefore)";
            options = {
              desc = "Put Text Before Cursor";
            };
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "gp";
            action = "<Plug>(YankyGPutAfter)";
            options = {
              desc = "Put Text After Selection";
            };
          }
          {
            mode = [
              "n"
              "x"
            ];
            key = "gP";
            action = "<Plug>(YankyGPutBefore)";
            options = {
              desc = "Put Text Before Selection";
            };
          }
          {
            mode = "n";
            key = "[y";
            action = "<Plug>(YankyCycleForward)";
            options = {
              desc = "Cycle Forward Through Yank History";
            };
          }
          {
            mode = "n";
            key = "]y";
            action = "<Plug>(YankyCycleBackward)";
            options = {
              desc = "Cycle Backward Through Yank History";
            };
          }
          {
            mode = "n";
            key = "]p";
            action = "<Plug>(YankyPutIndentAfterLinewise)";
            options = {
              desc = "Put Indented After Cursor (Linewise)";
            };
          }
          {
            mode = "n";
            key = "[p";
            action = "<Plug>(YankyPutIndentBeforeLinewise)";
            options = {
              desc = "Put Indented Before Cursor (Linewise)";
            };
          }
          {
            mode = "n";
            key = "]P";
            action = "<Plug>(YankyPutIndentAfterLinewise)";
            options = {
              desc = "Put Indented After Cursor (Linewise)";
            };
          }
          {
            mode = "n";
            key = "[P";
            action = "<Plug>(YankyPutIndentBeforeLinewise)";
            options = {
              desc = "Put Indented Before Cursor (Linewise)";
            };
          }
          {
            mode = "n";
            key = ">p";
            action = "<Plug>(YankyPutIndentAfterShiftRight)";
            options = {
              desc = "Put and Indent Right";
            };
          }
          {
            mode = "n";
            key = "<p";
            action = "<Plug>(YankyPutIndentAfterShiftLeft)";
            options = {
              desc = "Put and Indent Left";
            };
          }
          {
            mode = "n";
            key = ">P";
            action = "<Plug>(YankyPutIndentBeforeShiftRight)";
            options = {
              desc = "Put Before and Indent Right";
            };
          }
          {
            mode = "n";
            key = "<P";
            action = "<Plug>(YankyPutIndentBeforeShiftLeft)";
            options = {
              desc = "Put Before and Indent Left";
            };
          }
          {
            mode = "n";
            key = "=p";
            action = "<Plug>(YankyPutAfterFilter)";
            options = {
              desc = "Put After Applying a Filter";
            };
          }
          {
            mode = "n";
            key = "=P";
            action = "<Plug>(YankyPutBeforeFilter)";
            options = {
              desc = "Put Before Applying a Filter";
            };
          }
        ];
      };
    };
  };
}
