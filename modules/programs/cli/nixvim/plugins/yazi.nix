{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.yazi.enable {
    plugins.yazi = {
      enable = true;
      settings = {
        enable_mouse_support = true;
        open_for_directories = true;
        yazi_floating_window_border = "rounded";
      };
    };
    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>yy";
        action = "<cmd>Yazi<cr>";
        options = {
          desc = "Open yazi at the current file";
        };
      }
      {
        key = "<leader>yw";
        action = "<cmd>Yazi cwd<cr>";
        options = {
          desc = "Open the file manager in nvim's working directory";
        };
      }
      {
        key = "<leader>ys";
        action = "<cmd>Yazi toggle<cr>";
        options = {
          desc = "Resume the last yazi session";
        };
      }
    ];
  };
}
