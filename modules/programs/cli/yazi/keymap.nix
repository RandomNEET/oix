{ opts, ... }:
{
  mgr = {
    prepend_keymap = [
      # Goto
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
        run = "cd ~/oix";
        desc = "Go ~/oix";
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
    ]
    ++ (opts.yazi.keymap.mgr.prepend_keymap or [ ]);
  };
}
