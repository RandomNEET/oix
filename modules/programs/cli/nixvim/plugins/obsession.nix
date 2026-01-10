{ pkgs, ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>ss";
        action = ":Obsess<CR>";
        options = {
          desc = "Toggle session recording";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = ":source Session.vim<CR>";
        options = {
          desc = "Load local session";
          silent = true;
        };
      }
    ];
    extraPlugins = with pkgs.vimPlugins; [
      vim-obsession
    ];
  };
}
