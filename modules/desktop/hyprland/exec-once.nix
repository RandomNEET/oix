{
  osConfig,
  lib,
  pkgs,
  opts,
  getExe,
  getExe',

  ...
}:
[
  "noctalia-shell"
]
++ lib.optional (
  ((opts ? terminal) && (opts.terminal == "foot")) && (opts.foot.server or false)
) "${getExe pkgs.foot} --server"
++ [ "hyprctl dispatch workspace 1" ]
