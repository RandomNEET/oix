{ opts, ... }:
{
  mgr = {
    prepend_keymap = [
      # Linemode
      {
        on = [
          "M"
          "s"
        ];
        run = "linemode size";
        desc = "Linemode: size";
      }
      {
        on = [
          "M"
          "p"
        ];
        run = "linemode permissions";
        desc = "Linemode: permissions";
      }
      {
        on = [
          "M"
          "b"
        ];
        run = "linemode btime";
        desc = "Linemode: btime";
      }
      {
        on = [
          "M"
          "m"
        ];
        run = "linemode mtime";
        desc = "Linemode: mtime";
      }
      {
        on = [
          "M"
          "o"
        ];
        run = "linemode owner";
        desc = "Linemode: owner";
      }
      {
        on = [
          "M"
          "n"
        ];
        run = "linemode none";
        desc = "Linemode: none";
      }
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
