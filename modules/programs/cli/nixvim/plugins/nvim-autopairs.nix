{ ... }:
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
          end_key = "$";
          map = "<M-e>";
        };
      };
    };
  };
}
