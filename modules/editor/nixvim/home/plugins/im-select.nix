{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.i18n.inputMethod;
  backends = {
    fcitx5 = {
      default_command = "fcitx5-remote";
      default_im_select = "keyboard-us";
    };
  };
  backend = if cfg.type == null then null else backends.${cfg.type} or null;
in
{
  programs.nixvim = lib.mkIf (cfg.enable && backend != null) {
    extraPlugins = with pkgs.vimPlugins; [ im-select-nvim ];
    extraConfigLua = ''
      -- Seed the state before the first InsertEnter
      vim.g.im_select_saved_state = ${config.lib.nixvim.toLuaObject backend.default_im_select}
      require("im_select").setup(${
        config.lib.nixvim.toLuaObject (backend // { set_default_events = [ "InsertLeave" ]; })
      })
    '';
  };
}
