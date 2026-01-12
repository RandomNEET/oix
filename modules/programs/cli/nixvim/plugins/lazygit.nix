{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.lazygit.enable {
    plugins.lazygit = {
      enable = true;
    };
    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "<leader>lg";
        action = "<cmd>LazyGit<cr>";
        options = {
          desc = "Open lazygit";
        };
      }
    ];
  };
}
