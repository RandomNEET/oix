{ mylib, opts, ... }:
let
  display = opts.display or [ ];
  primaryDisplay = mylib.display.getPrimary display;
in
{
  mgr = {
    show_hidden = false;
    show_symlink = true;
    sort_dir_first = true;
    linemode = "size"; # or size, permissions, owner, mtime
    ratio = [
      # or 0 3 4
      1
      3
      4
    ];
  };
  preview = {
    tab_size = 4;
    image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
    max_width = primaryDisplay.width or 600;
    max_height = primaryDisplay.height or 900;
    image_quality = 90;
  };
}
