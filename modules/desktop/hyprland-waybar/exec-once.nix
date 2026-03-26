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
  "${randomwallctl} -r"
]
++ lib.optional (
  ((opts ? terminal) && (opts.terminal == "foot")) && (opts.foot.server or false)
) "${getExe pkgs.foot} --server"
++ [ "hyprctl dispatch workspace 1" ]
