{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.opencode.enable {
    keymaps = [
      {
        mode = [
          "n"
          "x"
        ];
        key = "<C-a>";
        action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<CR>";
        options = {
          desc = "Ask opencode";
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<C-x>";
        action = "<cmd>lua require('opencode').select()<CR>";
        options = {
          desc = "Execute opencode action…";
        };
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<C-.>";
        action = "<cmd>lua require('opencode').toggle()<CR>";
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
        action = "<cmd>lua require('opencode').command('session.half.page.up')<CR>";
        options = {
          desc = "opencode half page up";
        };
      }
      {
        mode = "n";
        key = "<S-C-d>";
        action = "<cmd>lua require('opencode').command('session.half.page.down')<CR>";
        options = {
          desc = "opencode half page down";
        };
      }
    ];
    plugins = {
      opencode = {
        enable = true;
        settings = {
          auto_reload = false;
        };
      };
    };
  };
}
