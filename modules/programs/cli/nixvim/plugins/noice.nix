{
  programs.nixvim = {
    plugins = {
      noice = {
        enable = true;
        settings = {
          cmdline = {
            enabled = true;
            view = "cmdline_popup";
          };
          messages = {
            enabled = true;
          };
          popupmenu = {
            enabled = true;
            backend = "nui";
          };
          notify = {
            enabled = true;
          };
          lsp = {
            message = {
              enabled = true;
            };
            progress = {
              enabled = false;
              view = "mini";
            };
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          views = {
            cmdline_popup = {
              position = {
                row = 3;
                col = "50%";
              };
              size = {
                width = 60;
                height = "auto";
              };
            };
            popupmenu = {
              relative = "editor";
              position = {
                row = 6;
                col = "50%";
              };
              size = {
                width = 60;
                height = 10;
              };
              border = {
                style = "rounded";
                padding = [
                  0
                  1
                ];
              };
            };
          };
          format = {
            filter = {
              pattern = [
                ":%s*%%s*s:%s*"
                ":%s*%%s*s!%s*"
                ":%s*%%s*s/%s*"
                "%s*s:%s*"
                ":%s*s!%s*"
                ":%s*s/%s*"
              ];
              icon = "";
              lang = "regex";
            };
            replace = {
              pattern = [
                ":%s*%%s*s:%w*:%s*"
                ":%s*%%s*s!%w*!%s*"
                ":%s*%%s*s/%w*/%s*"
                "%s*s:%w*:%s*"
                ":%s*s!%w*!%s*"
                ":%s*s/%w*/%s*"
              ];
              icon = "󱞪";
              lang = "regex";
            };
          };
          presets = {
            bottom_search = false;
            command_palette = false;
            inc_rename = false;
            long_message_to_split = false;
            lsp_doc_border = false;
          };
        };
      };
    };
  };
}
