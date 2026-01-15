{
  lib,
  pkgs,
  opts,
  getExe,
  getExe',
  ...
}:
[
  "dbus-update-activation-environment --systemd --all"
  "wl-clipboard-history -t"
  "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
  "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
  "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
  "${lib.optionalString (
    (opts.terminal == "foot") && (opts.foot.server or false)
  ) "${getExe pkgs.foot} --server"}"
  "hyprctl dispatch workspace 1"
]
