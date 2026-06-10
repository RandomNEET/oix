{ osConfig, mylib, ... }:
let
  display = osConfig.base.display.info;
  primaryDisplay = mylib.display.getPrimary display;
in
{
  mgr = {
    sort_by = "natural";
    sort_sensitive = false;
    sort_reverse = false;
    sort_dir_first = true;
    sort_translit = false;
    linemode = "mtime";
    show_hidden = false;
    show_symlink = true;
    ratio = [
      1
      3
      4
    ];
  };
  preview = {
    tab_size = 4;
    image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
    max_width = (primaryDisplay.width or 1200) / 2;
    max_height = primaryDisplay.height or 900;
    image_quality = 90;
  };
}
