{
  lib,
  pkgs,
  opts,
  randomwallctl,
  getExe,
  ...
}:
[
  { sh = "systemctl --user restart lxqt-policykit-agent.service"; }
  { sh = "wl-clipboard-history -t"; }
  { sh = "wl-paste --type text --watch cliphist store"; }
  { sh = "wl-paste --type image --watch cliphist store"; }
  { sh = "rm $XDG_CACHE_HOME/cliphist/db"; }
  { sh = "nm-applet --indicator"; }
  { sh = "${randomwallctl} -r"; }
]
++ lib.optional (((opts.terminal or "") == "foot") && (opts.foot.server or false)) {
  sh = "${getExe pkgs.foot} --server";
}
