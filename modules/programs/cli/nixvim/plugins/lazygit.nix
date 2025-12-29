{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.lazygit.enable {
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
    plugins.lazygit = {
      enable = true;
      settings = {
      };
    };
  };
}
