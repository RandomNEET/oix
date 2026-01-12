{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-obsession
    ];
    keymaps = [
      {
        mode = "n";
        key = "<leader>ss";
        action = ":Obsess<cr>";
        options = {
          desc = "Toggle session recording";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = ":source Session.vim<cr>";
        options = {
          desc = "Load local session";
          silent = true;
        };
      }
    ];
  };
}
