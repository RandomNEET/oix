{
  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;
        settings = {
          iconsEnabled = true;
          extensions = [
            "quickfix"
          ];
          options = {
            theme = "catppuccin";
            globalstatus = true;
            disabled_filetypes = {
              statusline = [
                "snack_dashboard"
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
          sections.lualine_c = [ "filename" ];
          sections.lualine_x = [ "location" ];
          tabline = { };
          winbar = { };
          inactive_winbar = { };
        };
      };
    };
  };
}
