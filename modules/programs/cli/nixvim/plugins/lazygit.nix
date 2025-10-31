{ config, lib, ... }:
{
  programs.nixvim = {
    keymaps = lib.mkIf config.programs.lazygit.enable [
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
      enable = config.programs.lazygit.enable;
      settings = {
      };
    };
  };
}
