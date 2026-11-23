{ config, lib, ... }:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = lib.mkIf config.programs.lazygit.enable {
      plugins.lazygit = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings = {
            cmd = "LazyGit";
          };
        };
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
  });
}
