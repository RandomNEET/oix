{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.opencode.enable {
    plugins.opencode = {
      enable = true;
      settings = {
        auto_reload = false;
      };
      lazyLoad = {
        enable = true;
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };
    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>aa";
        action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<cr>";
        options = {
          desc = "Ask opencode";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>as";
        action = "<cmd>lua require('opencode').select()<cr>";
        options = {
          desc = "Execute opencode action…";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "ao";
        action = "require('opencode').operator('@this ')";
        options = {
          expr = true;
          desc = "Add range to opencode";
        };
      }
      {
        mode = "n";
        key = "aoo";
        action = "require('opencode').operator('@this ') .. '_'";
        options = {
          expr = true;
          desc = "Add line to opencode";
        };
      }
      {
        mode = "n";
        key = "<S-C-u>";
        action = "<cmd>lua require('opencode').command('session.half.page.up')<cr>";
        options = {
          desc = "opencode half page up";
        };
      }
      {
        mode = "n";
        key = "<S-C-d>";
        action = "<cmd>lua require('opencode').command('session.half.page.down')<cr>";
        options = {
          desc = "opencode half page down";
        };
      }
    ];
  };
}
