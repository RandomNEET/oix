{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.kitty.enable {
    plugins.kitty-scrollback = {
      enable = true;
      settings = {
        readonly = {
          paste_window = {
            yank_register_enabled = false;
          };
          keymaps_enabled = false;
          status_window = {
            autoclose = true;
          };
          kitty_get_text = {
            extent = "all";
            ansi = true;
          };
        };
      };
    };
  };
}
