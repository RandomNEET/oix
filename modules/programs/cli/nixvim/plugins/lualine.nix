{
  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;
        settings = {
          iconsEnabled = true;
          theme = "auto";
          extensions = [
            "quickfix"
          ];
          options = {
            globalstatus = true;
            disabled_filetypes = {
              statusline = [
                "snacks_dashboard"
                "snacks_picker_list"
              ];
            };
            component_separators.left = "";
            component_separators.right = "";
            section_separators.left = "";
            section_separators.right = "";
            refresh = {
              statusline = 1000;
              tabline = 1000;
              winbar = 1000;
            };
          };
          sections = {
            lualine_a = [
              "mode"
              {
                __raw = ''
                  function()
                    local reg = vim.fn.reg_recording()
                    if reg == "" then return "" end
                    return "Recording @" .. reg
                  end
                '';
              }
              {
                __raw = "function() return vim.fn['ObsessionStatus']('[$]', '') end";
                cond = ''
                  function()
                    return vim.fn['ObsessionStatus']('[$]', ''') ~= ""
                  end
                '';
              }
            ];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = [ "filename" ];
            lualine_x = [
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [ "progress" ];
            lualine_z = [ "location" ];
          };
          inactive_sections = {
            lualine_a = [ ];
            lualine_b = [ ];
            lualine_c = [ "filename" ];
            lualine_x = [ "location" ];
            lualine_y = [ ];
            lualine_z = [ ];
          };
          tabline = { };
          winbar = { };
          inactive_winbar = { };
        };
      };
    };
  };
}
