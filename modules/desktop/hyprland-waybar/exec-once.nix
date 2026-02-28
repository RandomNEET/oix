{
  osConfig,
  lib,
  pkgs,
  opts,
  randomwallctl,
  getExe,
  getExe',
  ...
}:
[
  "nm-applet --indicator"
  "wl-clipboard-history -t"
  "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store" # clipboard store text data
  "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store" # clipboard store image data
  "rm '$XDG_CACHE_HOME/cliphist/db'" # Clear clipboard
  "${randomwallctl} -r"
]
++ lib.optional (
  ((opts.terminal or "") == "foot") && (opts.foot.server or false)
) "${getExe pkgs.foot} --server"
++ [ "hyprctl dispatch workspace 1" ]
