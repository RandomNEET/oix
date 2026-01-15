{
  osConfig,
  lib,
  pkgs,
  opts,
  powermodectl,
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
  "${lib.optionalString osConfig.services.power-profiles-daemon.enable "${powermodectl} -r"}"
  "${lib.optionalString (
    (opts.terminal == "foot") && (opts.foot.server or false)
  ) "${getExe pkgs.foot} --server"}"
  "hyprctl dispatch workspace 1"
]
