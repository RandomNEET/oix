{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.opencode.enable {
    plugins = {
      opencode = {
        enable = true;
        settings = {
          auto_reload = false;
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
        key = "<leader>ae";
        action = "<cmd>lua require('opencode').select()<cr>";
        options = {
          desc = "Execute opencode action…";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<leader>at";
        action = "<cmd>lua require('opencode').toggle()<cr>";
        options = {
          desc = "Toggle opencode";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "go";
        action = "require('opencode').operator('@this ')";
        options = {
          expr = true;
          desc = "Add range to opencode";
        };
      }
      {
        mode = "n";
        key = "goo";
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
