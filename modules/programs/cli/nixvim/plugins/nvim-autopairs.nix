{
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;
      settings = {
        disable_filetype = [
          "TelescopePrompt"
          "spectre_panel"
          "snacks_picker_input"
        ];
        fast_wrap = {
          map = "<M-e>";
          chars = [
            "{"
            "["
            "("
            "\""
            "'"
          ];
          pattern = "[[%'%\"%>%]%)%}%,]]";
          end_key = "$";
          before_key = "h";
          after_key = "l";
          cursor_pos_before = true;
          keys = "qwertyuiopzxcvbnmasdfghjkl";
          manual_position = true;
          highlight = "Search";
          highlight_grey = "Comment";
        };
      };
    };
  };
}
