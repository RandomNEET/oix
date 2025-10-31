{ opts, ... }:
{
  programs.yazi = {
    keymap = {
      mgr.prepend_keymap = [
        # Goto
        {
          on = [
            "g"
            "h"
          ];
          run = "cd ~";
          desc = "Go home";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/nixos";
          desc = "Go ~/nixos";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/dls";
          desc = "Go ~/dls";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = "cd ~/repo";
          desc = "Go ~/repo";
        }
        {
          on = [
            "g"
            "t"
          ];
          run = "cd ~/tmp";
          desc = "Go ~/tmp";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "Go ~/.config";
        }
        {
          on = [
            "g"
            "m"
          ];
          run = "cd /mnt";
          desc = "Go /mnt";
        }
        {
          on = [
            "g"
            "u"
          ];
          run = "cd /run/media/$USER";
          desc = "Go /run/media/$USER";
        }
        {
          on = [
            "g"
            "<Space>"
          ];
          run = "cd --interactive";
          desc = "Jump interactively";
        }
        {
          on = [
            "g"
            "f"
          ];
          run = "follow";
          desc = "Follow hovered symlink";
        }
        # Plugins
        {
          on = "<C-d>";
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }
        {
          on = "T";
          run = "plugin toggle-pane min-preview";
          desc = "Show or hide the preview pane";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
      ];
    };
  };
}
