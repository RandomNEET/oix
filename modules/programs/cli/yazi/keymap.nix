{ opts, ... }:
{
  mgr = {
    prepend_keymap = [
      {
        # Goto
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
          "c"
        ];
        run = "cd ~/.config";
        desc = "Go ~/.config";
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
    ]
    ++ (opts.yazi.keymap.mgr.prepend_keymap or [ ]);
  };
}
