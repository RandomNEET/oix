{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        background = {
          light = "latte";
          dark = "mocha";
        };
        term_colors = true;
        transparent_background = true;
        integrations = {
          blink_cmp = {
            style = "bordered";
          };
          flash = true;
          mini = {
            enabled = true;
            indentscope_color = "mauve";
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              information = [ "italic" ];
              warnings = [ "italic" ];
              ok = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              information = [ "underline" ];
              warnings = [ "underline" ];
              ok = [ "underline" ];
            };
            inlay_hints = {
              background = true;
            };
          };
          noice = true;
          notify = true;
          snacks = {
            enabled = true;
            indentscope_color = "mauve";
          };
          treesitter = true;
          treesitter_context = true;
          which_key = true;
        };
      };
    };
  };
}
